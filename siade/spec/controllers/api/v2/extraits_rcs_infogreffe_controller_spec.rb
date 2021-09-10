RSpec.describe API::V2::ExtraitsRCSInfogreffeController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'forbidden'
  it_behaves_like 'unprocessable_entity'
  it_behaves_like 'ask_for_mandatory_parameters'

  describe 'happy path' do
    before do
      get :show, params: { siren: siren, token: token }.merge(mandatory_params)
    end

    let(:response_body) do
      json = JSON.parse(response.body, symbolize_names: true)
    end

    context 'when user authenticates with valid token' do
      let(:token) { yes_jwt }

      context 'when siren is not found for infogreffe', vcr: { cassette_name: 'infogreffe_extrait_rcs_with_not_found_siren' } do
        let(:siren) { not_found_siren(:extrait_rcs) }

        it_behaves_like 'not_found', siren: not_found_siren(:extrait_rcs)
      end

      context 'when siren is known from infogreffe', vcr: { cassette_name: 'infogreffe_extrait_rcs_with_valid_siren' } do
        subject { response_body }

        let(:siren) { valid_siren(:extrait_rcs) }

        it 'returns code 200' do
          expect(response.code).to eq '200'
        end

        its([:siren]) { is_expected.to eq(valid_siren(:extrait_rcs)) }
        its([:date_immatriculation]) { is_expected.to eq('1998-03-27') }
        its([:date_immatriculation_timestamp]) { is_expected.to eq(890_953_200) }
        its([:date_extrait]) { is_expected.to match(/^[0-9]{2} [A-Z]+ [0-9]{4}/) }
        its([:observations]) { is_expected.to be_an(Array) }

        describe '#observations' do
          subject { response_body[:observations].first }

          it { is_expected.to be_a(Hash) }
          its([:date]) { is_expected.to eq('2000-02-23') }
          its([:date_timestamp]) { is_expected.to eq(951_260_400) }
          its([:numero]) { is_expected.to eq('12197') }
          its([:libelle]) { is_expected.to eq(' LA SOCIETE NE CONSERVE AUCUNE ACTIVITE A SON ANCIEN SIEGE ') }
        end
      end
    end
  end
end
