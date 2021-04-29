require 'rails_helper'

RSpec.describe RetrieverOrganizer, type: :organizer do
  before(:all) do
    class DummyRetrieverOrganizer < RetrieverOrganizer
      def provider_name
        context.provider_name
      end
    end
  end

  subject { DummyRetrieverOrganizer.call(params.merge(provider_name: provider_name)).status }

  describe 'provider_name method' do
    let(:params) { { set_status: 418 } }

    context 'when it is not a valid provider name' do
      let(:provider_name) { 'Invalid' }

      it 'raises an error' do
        expect {
          subject
        }.to raise_error(RetrieverOrganizer::InvalidProviderName)
      end
    end

    context 'when it is a valid provider name' do
      let(:provider_name) { 'INSEE' }

      it 'does not raise an error' do
        expect {
          subject
        }.not_to raise_error
      end
    end
  end
end
