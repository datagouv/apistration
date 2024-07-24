RSpec.describe APIParticulier::V3AndMore::BaseController do
  before(:all) do
    # rubocop:disable Style/ClassAndModuleChildren
    module APIParticulier::DummyResourceSerializer
      class V42 < APIParticulier::V3AndMore::BaseSerializer; end
    end
    # rubocop:enable Style/ClassAndModuleChildren
  end

  controller(described_class) do
    def index
      render json: { data: true }, status: :ok
    end

    def serializer_module
      APIParticulier::DummyResourceSerializer
    end

    def api_kind
      'api_particulier'
    end
  end

  describe 'version management' do
    before do
      get :index, params: { api_version:, token: yes_jwt }.merge(**api_particulier_mandatory_params)
    end

    context 'with a valid version' do
      let(:api_version) { 42 }

      its(:status) { is_expected.to be(200) }
    end

    context 'with invalid version' do
      let(:api_version) { 4 }

      its(:status) { is_expected.to be(404) }

      it 'serializes an error' do
        expect(response_json).to have_key(:errors)
      end

      describe '#body' do
        let(:errors) { response_json[:errors] }

        it do
          expect(errors).to include(
            hash_including(
              code: '00402',
              title: 'Version d\'API non prise en charge',
              detail: 'La version v4 n\'est pas supportée pour cet endpoint'
            )
          )
        end
      end
    end
  end

  describe 'recipient param' do
    let(:siret) { valid_siret }

    before do
      get :index, params: { api_version: 42, token: yes_jwt }
        .merge(**api_particulier_mandatory_params)
        .merge(recipient:, siret:)
    end

    context 'with valid siret as recipient' do
      let(:recipient) { valid_siret(:recipient) }

      its(:status) { is_expected.to be(200) }
    end

    context 'with invalid value as recipient' do
      let(:recipient) { 'invalid' }

      its(:status) { is_expected.to be(422) }

      it 'serializes an error' do
        expect(response_json).to have_key(:errors)
      end

      describe '#body' do
        let(:errors) { response_json[:errors] }

        it do
          expect(errors.pluck(:code)).to include('00210')
        end
      end
    end
  end
end
