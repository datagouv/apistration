RSpec.describe APIEntreprise::V3AndMore::Qualifelec::CertificatsController do
  subject do
    get :show,
      params: {
        api_version: 3,
        siret: '12345678901234',
        recipient: '55204599900828',
        context: 'test',
        object: 'certificats'
      }
  end

  let(:mocked_data) do
    {
      status: 200,
      payload: {
        what: 'ever'
      }
    }
  end

  before do
    request.headers['Authorization'] = "Bearer #{yes_jwt}"
  end

  describe 'when not in staging nor test' do
    before do
      allow(Rails).to receive(:env).and_return('production'.inquiry)
    end

    its(:status) { is_expected.to eq(501) }
  end

  describe 'when in staging' do
    before do
      allow(Rails).to receive(:env).and_return('staging'.inquiry)
      allow(MockService).to receive(:new).and_return(instance_double(MockService, mock: mocked_data))
    end

    its(:status) { is_expected.to eq(200) }
  end

  describe 'when in test' do
    before do
      allow(MockService).to receive(:new).and_return(instance_double(MockService, mock: mocked_data))
    end

    its(:status) { is_expected.to eq(200) }
  end
end
