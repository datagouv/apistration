RSpec.describe JwtTokenService do
  let(:seeds) { Seeds.new }

  describe '#extract_user' do
    subject(:extract_user) { described_class.new(jwt).extract_user }

    describe 'with a valid jwt' do
      context 'when it is the debugger uuid' do
        let(:jwt) { TokenFactory.new(['whatever']).valid(uid: JwtUser.debugger_id) }

        it { is_expected.to be_a(JwtUser) }

        its(:id) { is_expected.to eq(JwtUser.debugger_id) }
        its(:jti) { is_expected.to be_present }
        its(:siret) { is_expected.to eq(JwtTokenService::DINUM_SIRET) }

        its(:scopes) { is_expected.to eq(['whatever']) }
      end

      context 'when it is an another uuid' do
        let(:jwt) { TokenFactory.new(['invalid']).valid(uid:) }
        let(:uid) { SecureRandom.uuid }

        context 'when the uuid is not in the database' do
          it { is_expected.to be_nil }
        end

        context 'when the uuid is in the database' do
          let!(:token) do
            seeds.create_token(
              id: uid,
              iat: 1.day.ago.to_i,
              version: '1.0',
              exp: 18.months.from_now.to_i,
              scopes: ['valid']
            )
          end

          its(:id) { is_expected.to eq(uid) }
          its(:jti) { is_expected.to be_present }
          its(:siret) { is_expected.to eq(token.siret) }

          it 'takes scopes from db, not token' do
            expect(subject.scopes).to eq(['valid'])
          end

          it 'persists user in cache' do
            subject

            expect(EncryptedCache.read(jwt)).to be_present
          end

          context 'when user exists in cache (but not in database)' do
            let(:jwt) { TokenFactory.new(['from_cache']).valid(uid: SecureRandom.uuid) }
            let(:user_from_valid_jwt) { described_class.new(jwt).extract_user }

            before do
              EncryptedCache.write(jwt, user_from_valid_jwt)
            end

            it 'returns user from cache, not from database' do
              expect(subject).to eq(user_from_valid_jwt)
            end
          end

          describe 'when token has roles but not scopes (old token)' do
            let(:jwt) do
              payload = TokenFactory.new(['invalid']).payload(uid:)
              payload[:roles] = payload.delete(:scopes)

              JWT.encode(
                payload,
                Siade.credentials[:jwt_hash_secret],
                Siade.credentials[:jwt_hash_algo]
              )
            end

            it 'takes scopes from db, not token' do
              expect(subject.scopes).to eq(['valid'])
            end
          end
        end
      end
    end

    context 'with an invalid jwt' do
      let(:jwt) { 'not a valid jwt token' }

      it { is_expected.to be_nil }
    end
  end
end
