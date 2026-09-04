RSpec.describe INSEEPasswordRotationJob do
  subject(:rotate) { described_class.perform_now }

  let(:oauth_url) { INSEEAPIAuthentication::OAUTH_URL }
  let(:renewal_url) { INSEEPasswordRenewal::RENEWAL_URL }
  let(:current_password) { INSEE::PasswordDerivation.current_password }
  let(:previous_password) { INSEE::PasswordDerivation.previous_password }

  def stub_oauth_for(password, response)
    stub_request(:post, oauth_url)
      .with(body: hash_including('password' => password))
      .to_return(response)
  end

  def granted_response
    {
      status: 200,
      body: { access_token: 'a-fresh-insee-token', expires_in: 598_077 }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    }
  end

  def invalid_grant_response
    {
      status: 401,
      body: { error: 'invalid_grant' }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    }
  end

  before do
    Timecop.freeze(Date.new(2027, 1, 15))

    allow(Rails.env).to receive(:production?).and_return(true)
    ENV['FRONTAL'] = 'true'

    allow(MonitoringService.instance).to receive(:track)
  end

  after do
    Timecop.return
    ENV['FRONTAL'] = nil
  end

  describe 'guards' do
    before { stub_request(:post, oauth_url).to_return(granted_response) }

    it 'does nothing outside of the frontal machine' do
      ENV['FRONTAL'] = 'false'

      rotate

      expect(WebMock).not_to have_requested(:post, oauth_url)
    end

    it 'does nothing outside of production' do
      allow(Rails.env).to receive(:production?).and_return(false)

      rotate

      expect(WebMock).not_to have_requested(:post, oauth_url)
    end

    it 'does nothing while the bypass is active' do
      AdminApientreprise.credentials[INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY] = 'ByPass-Password1'

      rotate

      expect(WebMock).not_to have_requested(:post, oauth_url)
    ensure
      AdminApientreprise.credentials.delete(INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY)
    end

    it 'does nothing before the derivation starts' do
      Timecop.freeze(Date.new(2026, 10, 31))

      rotate

      expect(WebMock).not_to have_requested(:post, oauth_url)
    end

    it 'does not dig a potential account lock deeper' do
      Rails.cache.write(INSEEAPIAuthentication::FAILURE_CACHE_KEY, true, namespace: INSEEAPIAuthentication::CACHE_NAMESPACE)

      rotate

      expect(WebMock).not_to have_requested(:post, oauth_url)
    end
  end

  context 'when INSEE already holds the current password' do
    before do
      stub_oauth_for(current_password, granted_response)
      stub_request(:post, renewal_url)
    end

    it 'probes once' do
      rotate

      expect(WebMock).to have_requested(:post, oauth_url).once
    end

    it 'does not renew anything' do
      rotate

      expect(WebMock).not_to have_requested(:post, renewal_url)
    end

    it 'stays silent' do
      rotate

      expect(MonitoringService.instance).not_to have_received(:track)
    end
  end

  context 'when INSEE still holds the previous password' do
    before do
      stub_oauth_for(current_password, invalid_grant_response)
      stub_oauth_for(previous_password, granted_response)
    end

    context 'when the renewal is accepted' do
      before { stub_request(:post, renewal_url).to_return(status: 200, body: '{}') }

      it 'renews the password once' do
        rotate

        expect(WebMock).to have_requested(:post, renewal_url).once
          .with(body: { oldPassword: previous_password, newPassword: current_password }.to_json)
      end

      it 'authenticates with the token obtained from the previous password' do
        rotate

        expect(WebMock).to have_requested(:post, renewal_url)
          .with(headers: { 'Authorization' => 'Bearer a-fresh-insee-token' })
      end

      it 'reports the rotation' do
        rotate

        expect(MonitoringService.instance).to have_received(:track).with(
          'INSEE password rotated', level: :info, context: {}
        )
      end

      it 'costs a single failed authentication' do
        rotate

        expect(WebMock).to have_requested(:post, oauth_url).twice
      end
    end

    context 'when the renewal is rejected' do
      before { stub_request(:post, renewal_url).to_return(status: 400, body: '{"message":"nope"}') }

      it 'alerts with the INSEE answer' do
        rotate

        expect(MonitoringService.instance).to have_received(:track).with(
          'INSEE password rotation failed',
          level: :error,
          context: { http_response_code: 400, http_response_body: '{"message":"nope"}' }
        )
      end

      it 'does not retry the renewal' do
        rotate

        expect(WebMock).to have_requested(:post, renewal_url).once
      end
    end

    context 'when the renewal never reaches INSEE' do
      before { stub_request(:post, renewal_url).to_timeout }

      it 'alerts instead of letting the job crash' do
        rotate

        expect(MonitoringService.instance).to have_received(:track).with(
          'INSEE password renewal did not reach INSEE',
          level: :error,
          context: hash_including(:exception_message)
        )
      end
    end

    context 'when the previous password probe is unavailable' do
      before do
        stub_oauth_for(previous_password, { status: 503, body: '' })
        stub_request(:post, renewal_url)
      end

      it 'warns instead of claiming a desynchronization' do
        rotate

        expect(MonitoringService.instance).to have_received(:track).with(
          'INSEE password rotation skipped: OAuth unavailable',
          level: :warning,
          context: {}
        )
      end

      it 'does not renew anything' do
        rotate

        expect(WebMock).not_to have_requested(:post, renewal_url)
      end
    end
  end

  context 'when INSEE holds neither the current nor the previous password' do
    before do
      stub_request(:post, oauth_url).to_return(invalid_grant_response)
      stub_request(:post, renewal_url)
    end

    it 'alerts on the desynchronization' do
      rotate

      expect(MonitoringService.instance).to have_received(:track).with(
        'INSEE password desynchronized: neither current nor previous authenticates',
        level: :error,
        context: {}
      )
    end

    it 'does not renew anything' do
      rotate

      expect(WebMock).not_to have_requested(:post, renewal_url)
    end

    it 'costs two failed authentications at most' do
      rotate

      expect(WebMock).to have_requested(:post, oauth_url).twice
    end
  end

  context 'when OAuth is unavailable' do
    before do
      stub_request(:post, oauth_url).to_return(status: 503, body: '')
      stub_request(:post, renewal_url)
    end

    it 'warns and waits for the next run' do
      rotate

      expect(MonitoringService.instance).to have_received(:track).with(
        'INSEE password rotation skipped: OAuth unavailable',
        level: :warning,
        context: {}
      )
    end

    it 'does not probe the previous password' do
      rotate

      expect(WebMock).to have_requested(:post, oauth_url).once
    end

    it 'does not renew anything' do
      rotate

      expect(WebMock).not_to have_requested(:post, renewal_url)
    end
  end

  describe 'single execution' do
    it 'is limited to one enqueued or running job across every machine' do
      expect(described_class.good_job_concurrency_config).to include(
        total_limit: 1
      )
    end

    it 'shares a single concurrency key' do
      expect(described_class.good_job_concurrency_config[:key]).to eq(described_class::CONCURRENCY_KEY)
    end
  end
end
