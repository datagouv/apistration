RSpec.describe CNAF::QuotientFamilialV2, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        nom_naissance: 'CHAMPION',
        prenoms: ['JEAN-PASCAL'],
        annee_date_de_naissance: 1980,
        mois_date_de_naissance: 6,
        jour_date_de_naissance: 12,
        gender:,
        code_pays_lieu_de_naissance: '99100',
        code_insee_lieu_de_naissance: '17300',
        request_id: SecureRandom.uuid,
        user_siret: valid_siret,
        annee: 2023,
        mois: 12
      }
    end

    let(:gender) { 'M' }

    describe 'happy path' do
      before do
        stub_cnaf_authenticate('quotient_familial_v2')
        stub_cnaf_valid('quotient_familial_v2')
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end

    describe 'with a 404' do
      let(:monitoring_service) { instance_double(MonitoringService, track_provider_error: nil, set_provider: nil) }

      before do
        stub_cnaf_authenticate('quotient_familial_v2')
        stub_cnaf_404('quotient_familial_v2')
        allow(MonitoringService).to receive(:instance).and_return(monitoring_service)
        allow(monitoring_service).to receive(:track)
        allow(monitoring_service).to receive(:set_retriever_context)
      end

      it 'tracks error as a warning through monitoring service' do
        expect(subject).to be_a_failure
        expect(subject.errors).to include(instance_of(NotFoundError))
        expect(monitoring_service).to have_received(:set_provider)
        expect(monitoring_service).to have_received(:track).with(
          'warning',
          '[CNAF] - SNGI Error: Dossier allocataire inexistant. Le document ne peut être édité.'
        )
      end
    end

    describe 'with an invalid params' do
      let(:gender) { 'nope' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end
end
