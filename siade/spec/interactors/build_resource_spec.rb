require 'rails_helper'

RSpec.describe BuildResource, type: :interactor do
  before(:all) do
    class DummyBuildResource < BuildResource
      def call
        context.resource = context.dummy
      end
    end
  end

  subject { DummyBuildResource.call(dummy: dummy) }

  context 'when resource is nil on context' do
    let(:dummy) { nil }

    it 'raises an error' do
      expect {
        subject
      }.to raise_error(BuildResource::ResourceNotDefined)
    end
  end

  context 'when resource is defined on context' do
    let(:dummy) { 'whatever' }

    it 'does not raise an error' do
      expect {
        subject
      }.not_to raise_error
    end
  end
end
