RSpec.describe EditorDelegationResolver do
  let(:editor) { Editor.create!(name: 'Test Editor') }
  let(:user) { JwtUser.new(uid: SecureRandom.uuid, jti: SecureRandom.uuid, scopes: [], iat: 1.day.ago.to_i, editor_id: editor.id) }

  let(:authorization_request) { AuthorizationRequest.create!(siret: '13002526500013', scopes: %w[entreprises]) }
  let!(:delegation) { EditorDelegation.create!(editor:, authorization_request:) }

  describe '#resolve' do
    subject(:resolver) do
      described_class.new(user, params).tap(&:resolve)
    end

    context 'without recipient' do
      let(:params) { {} }

      it 'does not resolve a delegation' do
        expect(resolver.delegation).to be_nil
      end
    end

    context 'with matching recipient' do
      let(:params) { { 'recipient' => authorization_request.siret } }

      it 'resolves the delegation' do
        expect(resolver.delegation).to eq(delegation)
      end
    end

    context 'with non-matching recipient' do
      let(:params) { { 'recipient' => '99999999999999' } }

      it 'does not resolve' do
        expect(resolver.delegation).to be_nil
      end
    end

    context 'with revoked delegation' do
      before { delegation.update!(revoked_at: 1.day.ago) }

      let(:params) { { 'recipient' => authorization_request.siret } }

      it 'does not resolve' do
        expect(resolver.delegation).to be_nil
      end
    end

    context 'with multiple delegations for the same SIRET' do
      let(:params) { { 'recipient' => authorization_request.siret } }

      before do
        other_ar = AuthorizationRequest.create!(siret: authorization_request.siret, scopes: %w[etablissements])
        EditorDelegation.create!(editor:, authorization_request: other_ar)
      end

      it 'marks as ambiguous' do
        expect(resolver.ambiguous).to be true
      end

      it 'does not resolve' do
        expect(resolver.delegation).to be_nil
      end

      context 'with delegation_id to disambiguate' do
        let(:params) { { 'recipient' => authorization_request.siret, 'delegation_id' => delegation.id } }

        it 'resolves the targeted delegation' do
          expect(resolver.delegation).to eq(delegation)
        end

        it 'is not ambiguous' do
          expect(resolver.ambiguous).to be false
        end
      end

      context 'with invalid UUID as delegation_id' do
        let(:params) { { 'recipient' => authorization_request.siret, 'delegation_id' => 'not-a-uuid' } }

        it 'does not resolve' do
          expect(resolver.delegation).to be_nil
        end
      end
    end
  end

  describe '#enriched_user' do
    subject { resolver.enriched_user }

    let(:resolver) { described_class.new(user, params).tap(&:resolve) }

    context 'when delegation is resolved' do
      let(:params) { { 'recipient' => authorization_request.siret } }

      before do
        AuthorizationRequestSecuritySettings.create!(
          authorization_request:,
          allowed_ips: ['10.0.0.0/8'],
          rate_limit_per_minute: 42
        )
      end

      it 'returns a user enriched with delegation data' do
        expect(subject.authorization_request_id).to eq(authorization_request.id)
        expect(subject.scopes).to eq(authorization_request.scopes)
        expect(subject.allowed_ips).to eq(['10.0.0.0/8'])
        expect(subject.rate_limit_per_minute).to eq(42)
      end

      it 'preserves the editor_id' do
        expect(subject.editor_id).to eq(editor.id)
      end
    end

    context 'when no delegation is resolved' do
      let(:params) { {} }

      it 'returns the original user' do
        expect(subject).to eq(user)
      end
    end
  end
end
