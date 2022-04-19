RSpec.describe INPI::Authenticate::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'INPI') }

  let(:response) { instance_double(Net::HTTPOK) }

  context 'with a response containing a cookie' do
    before do
      allow(response).to receive(:[]).with('set-cookie').and_return('JSESSIONID=COOKIE; Path=/; Secure; HttpOnly')
    end

    it { is_expected.to be_a_success }
  end

  context 'with a response without a cookie' do
    before do
      allow(response).to receive(:[]).with('set-cookie').and_return(nil)
    end

    it { is_expected.to be_a_failure }
  end
end
