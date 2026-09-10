RSpec.describe INSEE::PasswordRotation do
  subject(:rotation) { described_class.new }

  let(:oauth_url) { INSEEOAuthExchange::OAUTH_URL }
  let(:renewal_url) { INSEEPasswordRenewal::RENEWAL_URL }
  let(:bypass_password) { 'ByPass-Password1' }
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

  def use_bypass_credential
    AdminApientreprise.credentials[INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY] = bypass_password
  end

  before do
    Timecop.freeze(Date.new(2027, 1, 15))

    allow(MonitoringService.instance).to receive(:track)
  end

  after do
    Timecop.return

    AdminApientreprise.credentials.delete(INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY)
  end

  describe '#rotate!' do
    context 'when INSEE already holds the current password' do
      before do
        stub_oauth_for(current_password, granted_response)
        stub_request(:post, renewal_url)
      end

      it { expect(rotation.rotate!).to eq(:already_current) }

      it 'costs a single OAuth call' do
        rotation.rotate!

        expect(WebMock).to have_requested(:post, oauth_url).once
      end

      it 'renews nothing' do
        rotation.rotate!

        expect(WebMock).not_to have_requested(:post, renewal_url)
      end
    end

    context 'when INSEE still holds the previous password' do
      before do
        stub_oauth_for(current_password, invalid_grant_response)
        stub_oauth_for(previous_password, granted_response)
        stub_request(:post, renewal_url).to_return(status: 200, body: '{}')
      end

      it { expect(rotation.rotate!).to eq(:renewed) }

      it 'renews the previous password into the current one' do
        rotation.rotate!

        expect(WebMock).to have_requested(:post, renewal_url).once
          .with(body: { oldPassword: previous_password, newPassword: current_password }.to_json)
      end
    end

    context 'when INSEE holds neither password' do
      before do
        stub_request(:post, oauth_url).to_return(invalid_grant_response)
        stub_request(:post, renewal_url)
      end

      it { expect(rotation.rotate!).to eq(:desynchronized) }

      it 'holds back the applicative authentications' do
        rotation.rotate!

        expect(INSEEAPIAuthentication.new).to be_recently_failed
      end

      it 'costs two failed authentications at most' do
        rotation.rotate!

        expect(WebMock).to have_requested(:post, oauth_url).twice
      end

      it 'renews nothing' do
        rotation.rotate!

        expect(WebMock).not_to have_requested(:post, renewal_url)
      end
    end

    context 'when OAuth is unavailable' do
      before { stub_request(:post, oauth_url).to_return(status: 503, body: '') }

      it 'reports it as unavailable' do
        expect { rotation.rotate! }.to raise_error(described_class::UnavailableError, /unavailable/)
      end

      it 'leaves the applicative authentications alone' do
        expect { rotation.rotate! }.to raise_error(described_class::UnavailableError)

        expect(INSEEAPIAuthentication.new).not_to be_recently_failed
      end
    end

    context 'when INSEE refuses the OAuth exchange itself' do
      before do
        stub_request(:post, oauth_url).to_return(
          status: 400,
          body: { error: 'invalid_client' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      it 'reports it' do
        expect { rotation.rotate! }.to raise_error(described_class::UnavailableError, /client credentials/)
      end

      it 'holds back the applicative authentications' do
        expect { rotation.rotate! }.to raise_error(described_class::UnavailableError)

        expect(INSEEAPIAuthentication.new).to be_recently_failed
      end
    end

    context 'when INSEE rejects the renewal' do
      before do
        stub_oauth_for(current_password, invalid_grant_response)
        stub_oauth_for(previous_password, granted_response)
        stub_request(:post, renewal_url).to_return(status: 400, body: '{"message":"nope"}')
      end

      it 'reports the provider answer' do
        expect { rotation.rotate! }.to raise_error(described_class::UnavailableError, /HTTP 400.*nope/)
      end
    end

    context 'when the renewal does not reach INSEE' do
      before do
        stub_oauth_for(current_password, invalid_grant_response)
        stub_oauth_for(previous_password, granted_response)
        stub_request(:post, renewal_url).to_timeout
      end

      it 'reports it instead of raising a bare Faraday error' do
        expect { rotation.rotate! }.to raise_error(described_class::UnavailableError, /did not reach INSEE/)
      end
    end
  end

  describe '#exit_bypass!' do
    context 'when no bypass credential is configured' do
      it 'refuses to run' do
        expect { rotation.exit_bypass! }.to raise_error(described_class::BypassNotInUseError)
      end
    end

    context 'when the derivation window has not opened yet' do
      before do
        Timecop.freeze(Date.new(2026, 9, 7))

        use_bypass_credential

        stub_request(:post, renewal_url)
      end

      it 'refuses to run' do
        expect { rotation.exit_bypass! }.to raise_error(described_class::DerivationNotStartedError)
      end

      it 'renews nothing' do
        expect { rotation.exit_bypass! }.to raise_error(described_class::DerivationNotStartedError)

        expect(WebMock).not_to have_requested(:post, renewal_url)
      end
    end

    context 'when INSEE holds the bypass password' do
      before do
        use_bypass_credential

        stub_oauth_for(current_password, invalid_grant_response)
        stub_oauth_for(bypass_password, granted_response)
        stub_request(:post, renewal_url).to_return(status: 200, body: '{}')
      end

      it { expect(rotation.exit_bypass!).to eq(:renewed) }

      it 'renews the bypass password into the derived one' do
        rotation.exit_bypass!

        expect(WebMock).to have_requested(:post, renewal_url).once
          .with(body: { oldPassword: bypass_password, newPassword: current_password }.to_json)
      end
    end

    context 'when a previous run already renewed' do
      before do
        use_bypass_credential

        stub_oauth_for(current_password, granted_response)
        stub_request(:post, renewal_url)
      end

      it { expect(rotation.exit_bypass!).to eq(:already_current) }

      it 'does not renew a second time' do
        rotation.exit_bypass!

        expect(WebMock).not_to have_requested(:post, renewal_url)
      end
    end
  end
end
