RSpec.describe API::V2::BaseController, type: :controller do
  let!(:fake_retriever) do
    class FakeRetriever < SIADE::V2::Retrievers::GenericInformationRetriever
      def retrieve; end
    end

    FakeRetriever
  end

  controller(described_class) do
    skip_after_action :verify_authorized

    def index
      FakeRetriever.new.retrieve

      render json: { data: true }, status: :ok
    end
  end

  subject { get :index, params: { token: yes_jwt }.merge(**mandatory_params) }

  context 'when retriever does not raise error' do
    its(:code) { is_expected.to eq('200') }
    its(:body) { is_expected.to eq({ data: true }.to_json) }
  end

  context 'when retriever raise a ProviderInMaintenance error' do
    let(:provider_in_maintenance_error) { ProviderInMaintenance.new('INSEE') }

    before do
      allow_any_instance_of(FakeRetriever).to receive(:retrieve).and_raise(provider_in_maintenance_error)
    end

    its(:code) { is_expected.to eq('502') }
    its(:body) { is_expected.to include("Le fournisseur de données est en maintenance") }
  end
end
