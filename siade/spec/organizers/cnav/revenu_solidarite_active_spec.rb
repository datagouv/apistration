RSpec.describe CNAV::RevenuSolidariteActive, type: :retriever_organizer do
  let(:request_id) { SecureRandom.uuid }
  let(:recipient) { valid_siret }

  describe '.call with civility params' do
    subject { described_class.call(params:) }

    let(:common_params) do
      {
        nom_naissance: 'CHAMPION',
        prenoms: ['JEAN-PASCAL'],
        annee_date_naissance: 1980,
        mois_date_naissance: 6,
        jour_date_naissance: 12,
        sexe_etat_civil:,
        code_cog_insee_pays_naissance: '99100',
        request_id:,
        user_id: valid_siret,
        recipient:
      }
    end

    let(:sexe_etat_civil) { 'M' }

    context 'when it is with code insee lieu de naissance' do
      let(:params) do
        common_params.merge(
          code_cog_insee_commune_naissance: '17300'
        )
      end

      describe 'happy path' do
        before do
          stub_cnav_authenticate('revenu_solidarite_active')
          stub_cnav_valid('revenu_solidarite_active')
        end

        it { is_expected.to be_a_success }

        it 'retrieves the resource' do
          resource = subject.bundled_data.data

          expect(resource).to be_present
        end
      end

      describe 'with an invalid params' do
        let(:sexe_etat_civil) { 'nope' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
      end
    end
  end

  describe '.call with FranceConnect params' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        nom_usage: 'MARTIN',
        nom_naissance: 'DUPONT',
        prenoms: ['Jean Martin'],
        annee_date_naissance: 2000,
        mois_date_naissance: 1,
        jour_date_naissance: 1,
        code_cog_insee_commune_naissance: '75101',
        code_cog_insee_pays_naissance: '99100',
        sexe_etat_civil: 'M',
        user_id: 'france_connect_client_name',
        request_id:,
        recipient:
      }
    end

    describe 'happy path' do
      before do
        stub_cnav_authenticate('revenu_solidarite_active')
        stub_cnav_valid_with_franceconnect_data('revenu_solidarite_active')
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
