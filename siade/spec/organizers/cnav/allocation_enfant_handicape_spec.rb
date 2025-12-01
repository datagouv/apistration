RSpec.describe CNAV::AllocationEnfantHandicape, type: :retriever_organizer do
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
          stub_cnav_authenticate('allocation_enfant_handicape')
          stub_cnav_valid('allocation_enfant_handicape')
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

      describe 'with a 404' do
        before do
          stub_cnav_authenticate('allocation_enfant_handicape')
        end

        describe 'when the error comes from CNAF' do
          before do
            stub_cnav_404('allocation_enfant_handicape', 'CNAF')
          end

          it 'returns 404 message for CNAF' do
            expect(subject).to be_a_failure
            expect(subject.errors).to include(instance_of(NotFoundError))
            expect(subject.errors.first.detail).to eq("Le dossier allocataire n'a pas été trouvé auprès de la CNAF.")
          end
        end

        describe 'when the error comes from MSA' do
          before do
            stub_cnav_404('allocation_enfant_handicape', 'MSA')
          end

          it 'returns 404 message for MSA' do
            expect(subject).to be_a_failure
            expect(subject.errors).to include(instance_of(NotFoundError))
            expect(subject.errors.first.detail).to eq("Le dossier allocataire n'a pas été trouvé auprès de la MSA.")
          end
        end

        describe 'when the error comes from sub provider' do
          before do
            stub_sngi_404('allocation_enfant_handicape')
          end

          it 'returns 422 message for SNGI' do
            expect(subject).to be_a_failure
            expect(subject.errors).to include(instance_of(UnprocessableEntityError))
            expect(subject.errors.first.detail).to eq("Les paramètres fournis ne permettent pas d'identifier un allocataire.")
          end
        end

        describe 'when the error comes from RNCPS' do
          before do
            stub_rncps_404('allocation_enfant_handicape')
          end

          it 'returns 404 message for RNCPS' do
            expect(subject).to be_a_failure
            expect(subject.errors).to include(instance_of(NotFoundError))
            expect(subject.errors.first.detail).to eq("L'allocataire n'est pas référencé auprès des caisses éligibles")
          end
        end

        describe 'when the error comes from anything else' do
          before do
            stub_cnav_404('allocation_enfant_handicape')
          end

          it 'returns 404 unexpected message' do
            expect(subject).to be_a_failure
            expect(subject.errors).to include(instance_of(NotFoundError))
            expect(subject.errors.first.detail).to eq('Une erreur inattendue est survenue lors de la collecte des données')
          end
        end
      end
    end
  end

  describe '.call with FranceConnect params' do
    let(:params) do
      {
        nom_usage: 'MARTIN',
        nom_naissance: 'DUPONT',
        prenoms: ['Jean Martin'],
        annee_date_naissance: Time.zone.today.year - 20,
        mois_date_naissance: 1,
        jour_date_naissance: 1,
        code_cog_insee_commune_naissance: '75101',
        code_cog_insee_pays_naissance: '99100',
        sexe_etat_civil: 'M',
        user_id: 'france_connect_client_name',
        request_id:
      }
    end

    describe 'happy path' do
      before do
        stub_cnav_authenticate('allocation_enfant_handicape')
        stub_cnav_valid_with_franceconnect_data('allocation_enfant_handicape')
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
