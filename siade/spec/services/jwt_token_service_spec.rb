RSpec.describe JwtTokenService do
  let(:seeds) { Seeds.new }

  describe '#extract_user' do
    subject(:extract_user) { described_class.instance.extract_user(jwt) }

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
          let(:monitoring_service) { MonitoringService.instance }
          let(:expiration_date) { 18.months.from_now.to_i }
          let(:extra_info) { {} }

          let!(:token) do
            seeds.create_token(
              id: uid,
              iat: 1.day.ago.to_i,
              version: '1.0',
              extra_info:,
              exp: expiration_date,
              scopes: ['valid'],
              mcp: true
            )
          end

          before do
            allow(monitoring_service).to receive(:track)
          end

          its(:id) { is_expected.to eq(uid) }
          its(:jti) { is_expected.to be_present }
          its(:siret) { is_expected.to eq(token.siret) }
          its(:mcp) { is_expected.to be true }

          it 'takes scopes from db, not token' do
            expect(subject.scopes).to eq(['valid'])
          end

          it 'takes expiration from db, not token' do
            expect(subject.exp).to eq(expiration_date)
          end

          it 'persists user in cache' do
            subject

            expect(EncryptedCache.read(jwt)).to be_present
          end

          it 'does not track unmigrated token' do
            extract_user

            expect(monitoring_service).not_to have_received(:track)
          end

          context 'when user exists in cache (but not in database)' do
            let(:jwt) { TokenFactory.new(['from_cache']).valid(uid: SecureRandom.uuid) }
            let(:user_from_valid_jwt) { described_class.instance.extract_user(jwt) }

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
