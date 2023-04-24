RSpec.describe APIParticulier::V2::CNAF::QuotientFamilialV2Controller do
  subject { get :show, params: { token: } }

  let(:token) { TokenFactory.new.valid }

  let(:mocked_data) do
    {
      status: 200,
      payload: {
        what: 'ever'
      }
    }
  end

  describe 'when not in staging' do
    its(:status) { is_expected.to eq(501) }
  end

  describe 'when in staging' do
    before do
      allow(Rails).to receive(:env).and_return('staging'.inquiry)
      allow(MockService).to receive(:new).and_return(instance_double(MockService, mock: mocked_data))
    end

    its(:status) { is_expected.to eq(200) }
  end
end
