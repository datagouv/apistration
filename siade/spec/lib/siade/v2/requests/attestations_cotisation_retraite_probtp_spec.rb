RSpec.describe SIADE::V2::Requests::AttestationsCotisationRetraitePROBTP, type: :provider_request do
  subject { described_class.new(siret).perform }

  let(:url) { 'https://probtp_domain.gouv.fr/ws_ext/rest/certauth/mpsservices/getAttestationCotisation' }

  context 'bad formated request' do
    let(:siret) { invalid_siret }

    its(:http_code) { is_expected.to eq(422) }
    its(:errors) { is_expected.to have_error(invalid_siret_error_message) }
  end

  context 'well formated siret' do
    context 'siret non eligible', vcr: { cassette_name: 'probtp/attestation/with_non_eligible_siret' } do
      let(:siret) { non_eligible_siret(:probtp) }

      its(:http_code) { is_expected.to eq(404) }
      its(:errors) { is_expected.to have_error("Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel") }

      it 'has code 8 and message 01' do
        json = JSON.parse(subject.body, symbolize_names: true)
        expect(json[:entete][:code]).to include('8')
        expect(json[:entete][:message]).to include('01 Compte non éligible pour attestation de cotisation')
      end
    end

    context 'when returns error 500' do
      let(:siret) { eligible_siret(:probtp) }

      before do
        stub_request(:post, url).to_return(
          status: [
            '500',
            'Internal Server Error'
          ]
        )
      end

      its(:http_code) { is_expected.to eq(502) }
      its(:errors) { is_expected.to have_error('La réponse retournée par le fournisseur de données est invalide et a été identifié comme étant une erreur interne. Si le problème persiste, consultez la page de status ou contactez nous sur le support.') }
    end
  end
end
