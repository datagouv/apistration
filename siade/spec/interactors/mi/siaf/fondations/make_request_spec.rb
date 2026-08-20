RSpec.describe MI::SIAF::Fondations::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:, operation_id: 'api_entreprise_v3_mi_siaf_fondations') }

    let(:params) do
      {
        siren_or_siret_or_rnf: valid_rnf_id
      }
    end

    it { is_expected.to be_a_success }

    it 'serves the mocked payload matching the downcased param' do
      expect(subject.mocked_data[:payload].dig('data', 'identifiants', 'rnf')).to eq(valid_rnf_id)
    end

    it 'sets the mocked status' do
      expect(subject.status).to eq(200)
    end

    context 'with an unknown fondation' do
      let(:params) do
        {
          siren_or_siret_or_rnf: non_existing_rnf_id
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
