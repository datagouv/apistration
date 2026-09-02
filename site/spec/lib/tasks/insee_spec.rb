RSpec.describe 'insee:rotate_from_bypass', type: :rake do
  subject(:rotate_from_bypass) { Rake::Task['insee:rotate_from_bypass'].tap(&:reenable).invoke }

  let(:oauth_url) { INSEEAPIAuthentication::OAUTH_URL }
  let(:renewal_url) { INSEEPasswordRenewal::RENEWAL_URL }
  let(:bypass_password) { 'ByPass-Password1' }
  let(:current_password) { INSEE::PasswordDerivation.current_password }

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

  before(:all) { Rails.application.load_tasks unless Rake::Task.task_defined?('insee:rotate_from_bypass') }

  before do
    Timecop.freeze(Date.new(2027, 1, 15))

    AdminApientreprise.credentials[INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY] = bypass_password
  end

  after do
    Timecop.return

    AdminApientreprise.credentials.delete(INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY)
  end

  context 'when INSEE holds the bypass password' do
    before do
      stub_oauth_for(bypass_password, granted_response)
      stub_request(:post, renewal_url).to_return(status: 200, body: '{}')
    end

    it 'renews it into the derived one' do
      expect { rotate_from_bypass }.to output(/derived password/).to_stdout

      expect(WebMock).to have_requested(:post, renewal_url).once
        .with(body: { oldPassword: bypass_password, newPassword: current_password }.to_json)
    end
  end

  context 'when INSEE rejects the renewal' do
    before do
      stub_oauth_for(bypass_password, granted_response)
      stub_request(:post, renewal_url).to_return(status: 400, body: '{"message":"nope"}')
    end

    it 'exits with a non zero status' do
      expect { rotate_from_bypass }.to raise_error(SystemExit)
    end
  end

  context 'when INSEE already holds the derived password' do
    before do
      stub_oauth_for(bypass_password, invalid_grant_response)
      stub_oauth_for(current_password, granted_response)
      stub_request(:post, renewal_url)
    end

    it 'succeeds without renewing anything' do
      expect { rotate_from_bypass }.to output(/nothing to renew/).to_stdout

      expect(WebMock).not_to have_requested(:post, renewal_url)
    end
  end

  context 'when INSEE holds neither password' do
    before do
      stub_request(:post, oauth_url).to_return(invalid_grant_response)
      stub_request(:post, renewal_url)
    end

    it 'exits with a non zero status' do
      expect { rotate_from_bypass }.to raise_error(SystemExit)
    end

    it 'does not renew anything' do
      expect { rotate_from_bypass }.to raise_error(SystemExit)

      expect(WebMock).not_to have_requested(:post, renewal_url)
    end
  end
end
