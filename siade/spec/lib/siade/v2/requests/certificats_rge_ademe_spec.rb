RSpec.describe SIADE::V2::Requests::CertificatsRGEADEME, type: :provider_request do
  subject { described_class.new(siret).perform }

  context 'with a bad formated request' do
    let(:siret) { not_a_siret }

    its(:http_code) { is_expected.to eq(422) }
    its(:errors) { is_expected.to have_error(invalid_siret_error_message) }
  end

  context 'with a know siret for the provider', vcr: { cassette_name: 'ademe/rge/with_valid_siret' } do
    let(:siret) { valid_siret(:rge_ademe) }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors) { is_expected.to be_empty }
  end

  context 'non-regression test: when provider is found and there is an extra payload which describe the response', vcr: { cassette_name: 'ademe/rge/with_valid_siret_and_extra_payload_which_describe_the_payload' } do
    let(:siret) { valid_siret(:rge_ademe) }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors) { is_expected.to be_empty }
  end

  context 'non-regression test: when provider is not found and there is an extra payload which describe the response', vcr: { cassette_name: 'ademe/rge/with_not_found_siret_and_extra_payload_which_describe_the_payload', record: :new_episodes } do
    let(:siret) { not_found_siret(:rge_ademe) }

    its(:http_code) { is_expected.to eq(404) }
    its(:errors) { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
  end

  context 'with an unknown siret for the provider', vcr: { cassette_name: 'ademe/rge/with_not_found_siret' } do
    let(:siret) { not_found_siret(:rge_ademe) }

    its(:http_code) { is_expected.to eq(404) }
    its(:errors) { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
  end

  describe 'non-regression test: when ADEME timeout' do
    let(:siret) { valid_siret(:rge_ademe) }

    before do
      stub_request(:post, 'https://bo-ris.ademe.fr/api/search/company').to_timeout
    end

    its(:http_code) { is_expected.to eq(504) }
  end
end
