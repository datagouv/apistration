RSpec.describe MEN::Scolarites::PingMakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(token:) }

    let(:token) { 'jwt-access-token' }

    context 'with valid params' do
      before do
        stub_men_scolarites_ping
      end

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
