RSpec.describe Documents::Upload, :self_hosted_doc do
  describe '.call' do
    subject { described_class.call(doc_params) }

    let(:doc_params) do
      {
        filename: 'test.lol',
        content: 'much content'
      }
    end

    context 'when upload works' do
      it { is_expected.to be_success }

      its(:url) do
        is_expected.to be_a_valid_self_hosted_document_url('test.lol')
      end

      it 'returns the time before the URL expires' do
        expect(subject.url_expires_in).to eq(1.day.to_i)
      end
    end

    context 'when upload does no work' do
      let(:error) { Excon::Error::ServiceUnavailable.new('whatever') }

      before do
        allow(described_class).to receive(:storage_shared_connexion).and_raise(error)
      end

      it { is_expected.to be_failure }
      its(:errors) { is_expected.to include(instance_of(HostingServiceError)) }
    end
  end
end
