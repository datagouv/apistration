RSpec.describe RNM::EntreprisesArtisanales::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        siren: siren,
      }
    end

    context 'with a valid siren', vcr: { cassette_name: 'rnm_cma/valid_siren_json', match_requests_on: strict_match_vcr_requests_on_attributes } do
      let(:siren) { valid_siren(:rnm_cma) }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
