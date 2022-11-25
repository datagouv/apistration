RSpec.describe SIADE::V2::Responses::EORIDouanes, type: :provider_response do
  subject { request.perform.response }

  let(:request) { SIADE::V2::Requests::EORIDouanes.new(eori: eori) }

  describe 'success', vcr: { cassette_name: 'dgddi/eori/valid_eori' } do
    let(:eori) { valid_eori }

    its(:http_code) { is_expected.to eq 200 }
    its(:errors) { is_expected.to be_empty }
  end

  describe 'failure' do
    context 'with not found EORI', vcr: { cassette_name: 'dgddi/eori/non_existing_eori' } do
      let(:eori) { non_existing_eori }

      its(:http_code) { are_expected.to eq 404 }
      its(:errors) { is_expected.to have_error('Le numéro EORI indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
    end

    context 'when unauthorized by server', vcr: { cassette_name: 'dgddi/eori/forbidden' } do
      let(:eori) { valid_eori }

      before do
        allow(request).to receive(:client_id).and_return('invalid_client_id')
      end

      its(:http_code) { are_expected.to eq 502 }
      its(:errors) { is_expected.to have_error("L'authentification auprès du fournisseur de données 'DGDDI' a échoué") }
    end

    context 'when server returns an internal server error' do
      let(:eori) { valid_eori }
      let(:stub_response) do
        {
          status: 500,
          body: eori_expected_body.to_json
        }
      end
      let(:eori_expected_body) do
        {
          erreur: {
            status: '500',
            message: 'Internal Server Error',
            code: 'TECH001',
            libelle: 'Erreur technique interne'
          }
        }
      end

      before do
        stub_request(:get, /douane.gouv.fr/).to_return(stub_response)
      end

      its(:http_code) { are_expected.to eq 502 }
      its(:errors) { is_expected.to have_error('La réponse retournée par le fournisseur de données est invalide et a été identifié comme étant une erreur interne. Si le problème persiste, consultez la page de status ou contactez nous sur le support.') }
    end

    context 'when it is not a valid EORI format', vcr: { cassette_name: 'dgddi/eori/invalid_eori_format' } do
      let(:eori) { 'Z' }

      before do
        # we were not able to find an example that passes our validation AND trigger their error
        allow(request).to receive(:valid?).and_return(true)
      end

      its(:http_code) { are_expected.to eq 422 }
      its(:errors) { is_expected.to have_error('Le numéro de siret ou le numéro EORI n\'est pas correctement formatté') }
    end
  end
end
