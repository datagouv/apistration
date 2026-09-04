RSpec.describe AttestationToken do
  let(:payload) { { 'siret' => '13002526500013', 'emise_le' => '2026-07-29' } }
  let(:purpose) { :attestation_test_v1 }
  let(:token) { described_class.generate(payload, purpose:) }

  describe '.generate' do
    it 'produces URL-safe tokens' do
      expect(token).not_to match(%r{[+/=]})
    end

    it 'does not leak the payload in clear text' do
      expect(token).not_to include('13002526500013')
    end

    it 'compresses the payload before encryption' do
      bulky = payload.merge('donnees' => Array.new(50) { { 'label' => 'Base de ressources annuelles', 'valeur' => '40 923' } })

      expect(described_class.generate(bulky, purpose:).length).to be < bulky.to_json.length
    end
  end

  describe '.read' do
    it 'round-trips the payload under its purpose' do
      expect(described_class.read(token, purpose:)).to eq(payload)
    end

    it 'rejects a token read under another purpose' do
      expect { described_class.read(token, purpose: :attestation_other_v1) }
        .to raise_error(ActiveSupport::MessageEncryptor::InvalidMessage)
    end

    it 'rejects tampering' do
      expect { described_class.read(token.tr('AB', 'BA'), purpose:) }
        .to raise_error(ActiveSupport::MessageEncryptor::InvalidMessage)
    end

    it 'rejects garbage' do
      expect { described_class.read('garbage!!', purpose:) }
        .to raise_error(ActiveSupport::MessageEncryptor::InvalidMessage)
    end

    it 'is not readable with the general-purpose encryptor key' do
      foreign = StringEncryptorService.instance.encrypt_url_safe('{}')

      expect { described_class.read(foreign, purpose:) }
        .to raise_error(ActiveSupport::MessageEncryptor::InvalidMessage)
    end

    context 'with expires_in (opaque expiry — indistinguishable from an invalid token)' do
      let(:token) { described_class.generate(payload, purpose:, expires_in: 5.years) }

      it 'stays readable before the deadline' do
        Timecop.travel(4.years.from_now) do
          expect(described_class.read(token, purpose:)).to eq(payload)
        end
      end

      it 'raises InvalidMessage past the deadline' do
        expired = token

        Timecop.travel(5.years.from_now + 1.day) do
          expect { described_class.read(expired, purpose:) }
            .to raise_error(ActiveSupport::MessageEncryptor::InvalidMessage)
        end
      end
    end

    context 'with expires_at (explicit expiry — distinguishable, 410 vs 404)' do
      let(:token) { described_class.generate(payload, purpose:, expires_at: 5.minutes.from_now.to_i) }

      it 'stays readable while fresh, without exposing the expiry claim' do
        fresh = token

        Timecop.travel(4.minutes.from_now) do
          expect(described_class.read(fresh, purpose:)).to eq(payload)
        end
      end

      it 'raises Expired once stale' do
        stale = token

        Timecop.travel(6.minutes.from_now) do
          expect { described_class.read(stale, purpose:) }.to raise_error(described_class::Expired)
        end
      end
    end
  end

  describe '.visual_code' do
    subject(:visual_code) { described_class.visual_code(token) }

    it { is_expected.to match(/\A[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{2}\z/) }

    it 'is deterministic for a given token' do
      expect(visual_code).to eq(described_class.visual_code(token))
    end

    it 'differs between tokens' do
      other = described_class.generate(payload.merge('emise_le' => '2026-07-30'), purpose:)

      expect(visual_code).not_to eq(described_class.visual_code(other))
    end
  end

  describe '.verification_url' do
    it 'builds the public verification path on the given host' do
      expect(described_class.verification_url('abc'))
        .to eq('https://test.particulier.api.gouv.fr/attestations/verification/abc')
    end

    it 'derives the host from the environment, like the serializers do — never from a request' do
      allow(Rails.env).to receive(:production?).and_return(true)

      expect(described_class.verification_url('abc'))
        .to eq('https://particulier.api.gouv.fr/attestations/verification/abc')
    end
  end
end
