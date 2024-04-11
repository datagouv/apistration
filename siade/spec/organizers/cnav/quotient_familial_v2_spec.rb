RSpec.describe CNAV::QuotientFamilialV2, type: :retriever_organizer do
  let(:request_id) { SecureRandom.uuid }
  let(:recipient) { valid_siret }

  describe '.call with civility params' do
    subject { described_class.call(params:) }

    let(:common_params) do
      {
        nom_naissance: 'CHAMPION',
        prenoms: ['JEAN-PASCAL'],
        annee_date_de_naissance: 1980,
        mois_date_de_naissance: 6,
        jour_date_de_naissance: 12,
        gender:,
        code_pays_lieu_de_naissance: '99100',
        request_id:,
        annee: 2023,
        mois: 5,
        recipient:
      }
    end

    let(:gender) { 'M' }

    context 'when it is with transcogage params' do
      before do
        stub_cnav_authenticate('quotient_familial_v2')
      end

      let(:params) do
        common_params.merge(
          nom_commune_naissance:,
          annee_date_de_naissance: '2000',
          code_insee_departement_de_naissance: '92'
        )
      end

      context 'with valid params for transcogage', vcr: { cassette_name: 'insee/metadonnees/one_result' } do
        let!(:stubbed_cnav_request) do
          stub_cnav_valid('quotient_familial_v2', extra_params: { anneeDemandee: '2023', moisDemande: '05', codeLieuNaissance: '92036', dateNaissance: '2000-06-12' })
        end

        let(:nom_commune_naissance) { 'Gennevilliers' }

        it 'calls with the retrieved code insee lieu de naissance from INSEE::CommuneINSEECode' do
          subject

          expect(stubbed_cnav_request).to have_been_requested
        end

        it { is_expected.to be_a_success }

        it 'retrieves the resource' do
          resource = subject.bundled_data.data

          expect(resource).to be_present
        end
      end

      context 'with invalid transcogage params', vcr: { cassette_name: 'insee/metadonnees/no_result' } do
        let(:nom_commune_naissance) { 'invalid' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end
    end

    context 'when it is with code insee lieu de naissance' do
      let(:params) do
        common_params.merge(
          code_insee_lieu_de_naissance: '17300'
        )
      end

      describe 'happy path' do
        before do
          stub_cnav_authenticate('quotient_familial_v2')
          stub_cnav_valid('quotient_familial_v2', extra_params: { anneeDemandee: '2023', moisDemande: '05' })
        end

        it { is_expected.to be_a_success }

        it 'retrieves the resource' do
          resource = subject.bundled_data.data

          expect(resource).to be_present
        end
      end

      describe 'with a 404' do
        before do
          stub_cnav_authenticate('quotient_familial_v2')
        end

        describe 'when the error comes from MSA' do
          before do
            stub_cnav_404('quotient_familial_v2')
          end

          it 'returns 404 message for MSA' do
            expect(subject).to be_a_failure
            expect(subject.errors).to include(instance_of(NotFoundError))
            expect(subject.errors.first.detail).to eq("Le dossier allocataire n'a pas été trouvé auprès de la MSA.")
          end
        end

        describe 'when the error comes from SNGI' do
          before do
            stub_sngi_404('quotient_familial_v2')
          end

          it 'returns 404 message for SNGI' do
            expect(subject).to be_a_failure
            expect(subject.errors).to include(instance_of(NotFoundError))
            expect(subject.errors.first.detail).to eq("L'allocataire que vous cherchez n'a pas été reconnu")
          end
        end
      end

      describe 'with an invalid params' do
        let(:gender) { 'nope' }

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
        date_naissance: '2000-01-01',
        code_insee_lieu_de_naissance: '75101',
        code_pays_lieu_de_naissance: '99100',
        gender: 'M',
        user_id: 'france_connect_client_name',
        request_id:,
        recipient:
      }
    end

    describe 'happy path' do
      before do
        stub_cnav_authenticate('quotient_familial_v2')
        stub_cnav_valid_with_franceconnect_data('quotient_familial_v2')
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
