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

  describe 'status context' do
    let(:provider_name) { 'INSEE' }

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
