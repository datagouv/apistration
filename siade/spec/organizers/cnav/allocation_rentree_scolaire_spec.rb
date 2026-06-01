RSpec.describe CNAV::AllocationRentreeScolaire, type: :retriever_organizer do
  subject { described_class.call(params:, recipient:) }

  let(:request_id) { SecureRandom.uuid }
  let(:recipient) { valid_siret }

  describe '.call with civility params' do
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
        user_id: valid_siret
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
          stub_cnav_authenticate('allocation_rentree_scolaire')
          stub_cnav_valid('allocation_rentree_scolaire')
        end

        it { is_expected.to be_a_success }

        it 'retrieves the resource' do
          resource = subject.bundled_data.data

          expect(resource.status).to eq('allocataire')
          expect(resource.date_debut_droit).to eq('2024-08-09')
        end
      end

      describe 'with an invalid params' do
        let(:sexe_etat_civil) { 'nope' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
      end

      describe 'with a 404' do
        before do
          stub_cnav_authenticate('allocation_rentree_scolaire')
        end

        describe 'when the error comes from CNAF' do
          before do
            stub_cnav_404('allocation_rentree_scolaire', 'CNAF')
          end

          it 'returns 404 message for CNAF' do
            expect(subject).to be_a_failure
            expect(subject.errors).to include(instance_of(NotFoundError))
            expect(subject.errors.first.detail).to eq("Le dossier allocataire n'a pas été trouvé auprès de la CNAF.")
          end
        end
      end
    end
  end
end
