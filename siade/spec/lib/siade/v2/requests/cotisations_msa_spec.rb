RSpec.describe SIADE::V2::Requests::CotisationsMSA, type: :provider_request do
  subject { described_class.new(siret).perform }

  context 'bad formated request' do
    let(:siret) { not_a_siret }

    its(:http_code) { is_expected.to eq(422) }
    its(:errors) { is_expected.to have_error(invalid_siret_error_message) }
  end

  context 'well formated request', vcr: { cassette_name: 'non_regenerable/msa_web_service_cotisation_valid_siret' } do
    let(:siret) { valid_siret(:msa) }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors) { is_expected.to be_empty }
  end

  describe 'unprocessable entity', vcr: { cassette_name: 'cotisations_msa_unprocessable_entity' } do
    let(:siret) { '81104725700019' }

    its(:http_code) { should eq(502) }
    its(:errors) { is_expected.not_to be_empty }
  end
end
