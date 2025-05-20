require 'rails_helper'

RSpec.describe APIParticulier::V2::BaseController, 'errors rendering' do
  # rubocop:enable RSpec/DescribeMethod
  controller(described_class) do
    def show
      render_errors(organizer)
    end

    def organizer; end
  end

  # rubocop:disable RSpec/VerifiedDoubles
  subject do
    routes.draw { get 'show' => 'api_particulier/v2/base#show' }

    get :show, params: { token: }
  end

  let(:organizer) { double('organizer', mocked_data: nil, errors:) }
  # rubocop:enable RSpec/VerifiedDoubles

  let(:token) { yes_jwt }
  let(:errors) { [error] }

  # rubocop:disable RSpec/InstanceVariable
  before do
    allow(@controller).to receive(:organizer).and_return(organizer)
  end
  # rubocop:enable RSpec/InstanceVariable

  context 'with NotFoundError' do
    let(:error) { NotFoundError.new('whatever', 'message') }

    its(:status) { is_expected.to eq(404) }

    its(:body) do
      is_expected.to eq({
        error: 'not_found',
        reason: 'message Veuillez vérifier que votre recherche est couverte par le périmètre de l\'API.',
        message: 'message Veuillez vérifier que votre recherche est couverte par le périmètre de l\'API.'
      }.to_json)
    end
  end

  context 'with UnprocessableEntityError' do
    let(:error) { UnprocessableEntityError.new('siren') }

    its(:status) { is_expected.to eq(400) }

    its(:body) do
      is_expected.to eq({
        error: 'bad_request',
        reason: error.detail,
        message: error.detail
      }.to_json)
    end
  end

  context 'with token error (UnauthorizedError)' do
    let(:error) { InvalidTokenError.new }

    its(:status) { is_expected.to eq(401) }

    its(:body) do
      is_expected.to eq({
        error: 'access_denied',
        reason: error.detail,
        message: error.detail
      }.to_json)
    end
  end

  context 'with a provider error' do
    let(:error) { ProviderInternalServerError.new('whatever') }

    its(:status) { is_expected.to eq(503) }

    its(:body) do
      is_expected.to eq({
        error: 'data_provider_error',
        reason: error.detail,
        message: error.detail
      }.to_json)
    end
  end

  context 'with an InvalidRecipientError' do
    let(:error) { InvalidRecipientError.new }

    its(:status) { is_expected.to eq(400) }

    its(:body) do
      is_expected.to eq({
        error: 'bad_request',
        reason: error.detail,
        message: error.detail
      }.to_json)
    end
  end
end
