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
          it 'raises an extraction error stating the token is not found' do
            expect { extract_user }.to raise_error(JwtTokenService::ExtractionError) { |error| expect(error.reason).to eq(:not_found) }
          end
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
            let(:jwt) { TokenFactory.new(['from_cache']).valid(uid: cached_uid) }
            let(:cached_uid) { SecureRandom.uuid }
            let(:cached_user) { JwtUser.new(uid: cached_uid, jti: cached_uid, scopes: ['from_cache'], iat: 1.day.ago.to_i) }

            before do
              EncryptedCache.write(jwt, cached_user)
            end

            it 'returns user from cache, not from database' do
              expect(subject).to have_attributes(id: cached_uid, scopes: ['from_cache'])
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

    context 'with a malformed jwt' do
      let(:jwt) { 'not a valid jwt token' }

      it 'raises an extraction error stating the token is malformed' do
        expect { extract_user }.to raise_error(JwtTokenService::ExtractionError) { |error| expect(error.reason).to eq(:malformed) }
      end
    end

    context 'with a jwt signed with another secret' do
      let(:jwt) { JWT.encode(payload, 'another secret', Siade.credentials[:jwt_hash_algo]) }
      let(:payload) { TokenFactory.new(['whatever']).payload(uid: SecureRandom.uuid) }

      def extraction_error_reason
        extract_user
      rescue JwtTokenService::ExtractionError => e
        e.reason
      end

      it 'raises an extraction error stating the signature is invalid' do
        expect(extraction_error_reason).to eq(:invalid_signature)
      end

      context 'when on staging' do
        before do
          allow(Rails.env).to receive(:staging?).and_return(true)
        end

        it 'states it is a production token used on staging' do
          expect(extraction_error_reason).to eq(:production_token_on_staging)
        end

        context 'when the payload cannot be decoded' do
          let(:jwt) { corrupted_jwt }

          it 'only states the signature is invalid' do
            expect(extraction_error_reason).to eq(:invalid_signature)
          end
        end

        context 'when the payload is not an object' do
          let(:jwt) { JWT.encode([], 'another secret', Siade.credentials[:jwt_hash_algo]) }

          it 'only states the signature is invalid' do
            expect(extraction_error_reason).to eq(:invalid_signature)
          end
        end

        context 'when the token looks like the staging one' do
          let(:payload) { super().merge(sub: 'staging') }

          it 'only states the signature is invalid' do
            expect(extraction_error_reason).to eq(:invalid_signature)
          end
        end

        context 'when the token carries the staging jti' do
          let(:payload) { super().merge(jti: JwtTokenService::STAGING_TOKEN_JTI) }

          it 'only states the signature is invalid' do
            expect(extraction_error_reason).to eq(:invalid_signature)
          end
        end
      end

      context 'when on production' do
        before do
          allow(Rails.env).to receive(:production?).and_return(true)
        end

        it 'only states the signature is invalid' do
          expect(extraction_error_reason).to eq(:invalid_signature)
        end

        context 'when the token is the staging one' do
          let(:payload) { super().merge(sub: 'staging', jti: JwtTokenService::STAGING_TOKEN_JTI) }

          it 'states it is a staging token used on production' do
            expect(extraction_error_reason).to eq(:staging_token_on_production)
          end
        end
      end
    end
  end
end
