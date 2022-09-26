RSpec.describe DGFIP::Dictionaries::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(cookie:, params:) }

    let!(:cookie) { DGFIP::Authenticate.call.cookie }
    let(:params) do
      {
        year: 2019
      }
    end

    describe 'happy path', vcr: { cassette_name: 'dgfip/dictionaries/2019', decode_compressed_response: true } do
      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
