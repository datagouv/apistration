RSpec.describe SIADE::V2::Requests::EntreprisesArtisanales, type: :provider_request do
  subject { described_class.new(siren).perform }

  context 'bad formated request' do
    context 'invalid siren' do
      let(:siren) { invalid_siren }

      its(:http_code) { is_expected.to eq(422) }
      its(:errors) { is_expected.to have_error(invalid_siren_error_message) }
    end
  end

  context 'well formated request', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
    let(:siren) { valid_siren(:rnm_cma) }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors) { is_expected.to be_empty }
  end
end
