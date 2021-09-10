RSpec.describe API::V3AndMore::BaseController, type: :controller do
  before(:all) do
    # rubocop:disable Style/ClassAndModuleChildren
    module DummyResourceSerializer
      class V42 < JSONAPI::BaseSerializer; end
    end
    # rubocop:enable Style/ClassAndModuleChildren
  end

  controller(described_class) do
    def index
      render json: { data: true }, status: :ok
    end

    def serializer_module
      DummyResourceSerializer
    end
  end

  before do
    get :index, params: { api_version: api_version, token: yes_jwt }.merge(**mandatory_params)
  end

  context 'with valid version' do
    let(:api_version) { 42 }

    its(:status) { is_expected.to be(200) }

    it 'does not serialize an error' do
      expect(response_json).not_to have_key(:errors)
    end
  end

  context 'with invalid version' do
    let(:api_version) { 4 }

    its(:status) { is_expected.to be(404) }

    it 'serializes an error' do
      expect(response_json).to have_key(:errors)
    end

    describe '#body' do
      let(:error) { response_json.dig(:errors, 0) }

      it { expect(error&.dig(:code)).to eq('00402') }
      it { expect(error&.dig(:detail)).to eq('La version v4 n\'est pas supportée pour ce endpoint.') }
      it { expect(error&.dig(:title)).to eq('Version d\'API non prise en charge') }
    end
  end
end
