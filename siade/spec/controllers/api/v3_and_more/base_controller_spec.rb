RSpec.describe API::V3AndMore::BaseController, type: :controller do
  before(:all) do
    # rubocop:disable Style/ClassAndModuleChildren
    module DummyResourceSerializer
      class V42 < JSONAPI::BaseSerializer; end
    end
    # rubocop:enable Style/ClassAndModuleChildren
  end

  controller(described_class) do
    skip_after_action :verify_authorized

    def index
      render json: { data: true }, status: :ok
    end

    def serializer_module
      DummyResourceSerializer
    end
  end

  describe 'version management' do
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
        let(:errors) { response_json[:errors] }

        it do
          expect(errors).to include({
            code: '00402',
            title: 'Version d\'API non prise en charge',
            detail: 'La version v4 n\'est pas supportée pour cet endpoint'
          })
        end
      end
    end
  end

  describe 'recipient param' do
    let(:siret) { valid_siret }

    before do
      get :index, params: { api_version: 42, token: yes_jwt }
        .merge(**mandatory_params)
        .merge(recipient: recipient, siret: siret)
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
          expect(errors).to include({
            code: '00210',
            title: 'Entité non traitable',
            detail: 'Le paramètre recipient n\'est pas un siret valide',
            source: {
              parameter: 'recipient'
            }
          })
        end
      end
    end

    context 'with a recipient same as siret param' do
      let(:recipient) { valid_siret(:recipient) }
      let(:siret) { valid_siret(:recipient) }

      its(:status) { is_expected.to be(422) }

      it 'serializes an error' do
        expect(response_json).to have_key(:errors)
      end

      describe '#body' do
        let(:errors) { response_json[:errors] }

        it do
          expect(errors).to include({
            code: '00211',
            title: 'Entité non traitable',
            detail: 'Le paramètre recipient est identique au siret de la demande',
            source: {
              parameter: 'recipient'
            }
          })
        end
      end
    end
  end

  describe 'recipient param with a siren resource ID' do
    before do
      get :index, params: { api_version: 42, token: yes_jwt }
        .merge(**mandatory_params)
        .merge(recipient: recipient, siren: siren)
    end

    context 'when identical' do
      let(:recipient) { valid_siret(:recipient) }
      let(:siren) { valid_siren(:recipient) }

      its(:status) { is_expected.to be(422) }

      it 'serializes an error' do
        expect(response_json).to have_key(:errors)
      end

      describe '#body' do
        let(:errors) { response_json[:errors] }

        it do
          expect(errors).to include({
            code: '00211',
            title: 'Entité non traitable',
            detail: 'Le paramètre recipient est identique au siret de la demande',
            source: {
              parameter: 'recipient'
            }
          })
        end
      end
    end
  end
end
