require 'rails_helper'

RSpec.describe RetrieverOrganizer, type: :organizer do
  before(:all) do
    class DummyRetrieverInteractor < ApplicationInteractor
      def call
        if context.set_status
          context.status = context.set_status
        end
      end
    end

    class DummyRetrieverOrganizer < RetrieverOrganizer
      organize DummyRetrieverInteractor

      def provider_name
        'INSEE'
      end
    end
  end

  describe 'status context' do
    subject { DummyRetrieverOrganizer.call(params).status }

    context 'when there is no status defined' do
      let(:params) { {} }

      it 'raises an error' do
        expect {
          subject
        }.to raise_error(RetrieverOrganizer::StatusNotDefined)
      end
    end

    context 'when there is a status defined' do
      let(:params) { { set_status: 418 } }

      it 'does not raise an error' do
        expect {
          subject
        }.not_to raise_error
      end
    end
  end
end
