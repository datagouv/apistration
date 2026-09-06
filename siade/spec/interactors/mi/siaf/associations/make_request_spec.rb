RSpec.describe MI::SIAF::Associations::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:, operation_id: 'api_entreprise_v3_mi_siaf_associations') }

    let(:params) do
      {
        siren_or_siret_or_rna: siaf_association_rna_id
      }
    end

    it { is_expected.to be_a_success }

    it 'serves the mocked payload matching the param' do
      expect(subject.mocked_data[:payload].dig('data', 'identifiants', 'rna')).to eq(siaf_association_rna_id)
    end

    it 'sets the mocked status' do
      expect(subject.status).to eq(200)
    end

    context 'with a siren' do
      let(:params) do
        {
          siren_or_siret_or_rna: siaf_association_siren
        }
      end

      it 'serves the same association as its RNA id' do
        expect(subject.mocked_data[:payload].dig('data', 'identifiants', 'rna')).to eq(siaf_association_rna_id)
      end
    end

    context 'with an unknown association' do
      let(:params) do
        {
          siren_or_siret_or_rna: non_existing_rna_id
        }
      end

      it 'serves the not found payload' do
        expect(subject.status).to eq(404)
      end
    end

    context 'when outside staging and test environments' do
      before do
        allow(Rails.env).to receive_messages(staging?: false, test?: false)
      end

      it 'raises EndpointNotYetImplemented' do
        expect { subject }.to raise_error(MockedInteractor::EndpointNotYetImplemented)
      end
    end
  end
end
