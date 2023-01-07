RSpec.describe ScopesAuthorizationService, type: :service do
  describe '#allow?' do
    subject { described_class.new(user_scopes, controller) }

    context 'when user has at least one scope for controller' do
      let(:user_scopes) { %w[allowed_scope whatever_scope] }
      let(:controller) { 'ApiWhatever::WhateverResourceController' }

      it { is_expected.to be_allow }
    end

    context 'when user has no scope for controller' do
      let(:user_scopes) { %w[whatever_scope] }
      let(:controller) { 'ApiWhatever::WhateverResourceController' }

      it { is_expected.not_to be_allow }
    end
  end
end
