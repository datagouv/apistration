RSpec.describe API::V2::EORIDouanesController, type: :controller do
  it_behaves_like 'unauthorized', :show, siret_or_eori: valid_siret
  it_behaves_like 'forbidden', :show, siret_or_eori: valid_siret
  it_behaves_like 'ask_for_mandatory_parameters', :show, siret_or_eori: valid_siret

  describe 'valid mandatory_params & tokens' do
    subject do
      get :show, params: { siret_or_eori: siret_or_eori, token: token }.merge(mandatory_params)
    end

    let(:token) { yes_jwt }

    context 'with an invalid EORI' do
      let(:siret_or_eori) { invalid_eori }

      its(:status) { is_expected.to eq(422) }

      it 'returns an error' do
        subject
        expect(response_json)
          .to have_json_error(
            detail: "Le numéro de siret ou le numéro EORI n'est pas correctement formatté"
          )
      end
    end

    context 'with a non existing EORI', vcr: { cassette_name: 'douanes/eori/non_existing_eori' } do
      let(:siret_or_eori) { non_existing_eori }

      its(:status) { is_expected.to eq(404) }

      it 'returns an error' do
        subject
        expect(response_json)
          .to have_json_error(
            detail: 'Le numéro EORI indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel'
          )
      end
    end

    describe 'happy path', vcr: { cassette_name: 'douanes/eori/valid_eori' } do
      context 'with a valid EORI' do
        let(:siret_or_eori) { valid_eori }

        its(:status) { is_expected.to eq(200) }

        it 'returns a valid payload' do
          subject
          expect(response_json).to include(
            numero_eori: 'FR16002307300010',
            actif: true,
            raison_sociale: 'CENTRE INFORMATIQUE DOUANIER',
            rue: '27 R DES BEAUX SOLEILS',
            code_postal: '95520',
            ville: 'OSNY',
            pays: 'FRANCE',
            code_pays: 'FR'
          )
        end
      end

      context 'with a valid SIRET' do
        let(:siret_or_eori) { valid_eori.sub('FR', '') }

        it 'transform french SIRET into EORI' do
          expect(SIADE::V2::Retrievers::EORIDouanes)
            .to receive(:new)
            .with("FR#{siret_or_eori}")
            .and_call_original
          subject
        end

        its(:status) { is_expected.to eq(200) }

        it 'returns a valid payload' do
          subject
          expect(response_json).to include(
            numero_eori: 'FR16002307300010'
          )
        end
      end
    end
  end
end
