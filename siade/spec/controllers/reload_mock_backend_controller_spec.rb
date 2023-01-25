RSpec.describe ReloadMockBackendController do
  describe 'POST #create' do
    subject { post :create }

    context 'when it is staging environment' do
      before do
        allow(Rails.env).to receive(:staging?).and_return(true)
      end

      it { is_expected.to have_http_status(:ok) }

      it 'calls reset! on the mock backend' do
        expect(MockDataBackend).to receive(:reset!)

        subject
      end
    end

    context 'when it is not staging environment' do
      before do
        allow(Rails.env).to receive(:staging?).and_return(false)
      end

      it { is_expected.to have_http_status(:forbidden) }

      it 'does not call reset! on the mock backend' do
        expect(MockDataBackend).not_to receive(:reset!)

        subject
      end
    end
  end
end
