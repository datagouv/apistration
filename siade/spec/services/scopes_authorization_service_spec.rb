RSpec.describe ScopesAuthorizationService, type: :service do
  describe '#allow?' do
    subject { described_class.new(user_scopes, resource) }

    describe 'with controller resource name' do
      context 'when user has at least one scope for resource' do
        let(:user_scopes) { %w[allowed_scope whatever_scope] }
        let(:resource) { 'ApiWhatever::WhateverResourceController' }

        it { is_expected.to be_allow }
      end

      context 'when user has no scope for resource' do
        let(:user_scopes) { %w[whatever_scope] }
        let(:resource) { 'ApiWhatever::WhateverResourceController' }

        it { is_expected.not_to be_allow }
      end
    end

    context 'with mcp resource name' do
      context 'when user has at least one scope for resource' do
        let(:resource) { 'mcp/whatever/resource' }
        let(:user_scopes) { %w[allowed_scope whatever_scope] }

        it { is_expected.to be_allow }
      end

      context 'when user has no scope for resource' do
        let(:resource) { 'mcp/whatever/resource' }
        let(:user_scopes) { %w[whatever_scope] }

        it { is_expected.not_to be_allow }
      end
    end

    context 'with unknown resource name' do
      let(:resource) { 'UnknownResourceName' }
      let(:user_scopes) { %w[whatever_scope] }

      it 'raises an error' do
        expect { subject.allow? }.to raise_error(ScopesAuthorizationService::ResourceNameInvalidError, /is not valid/)
      end
    end
  end
end
