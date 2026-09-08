RSpec.describe INSEE::PasswordDerivation do
  after { Timecop.return }

  let(:static_password) { AdminApientreprise.credentials[described_class::STATIC_CREDENTIAL_KEY] }

  describe '.current_period' do
    it 'returns the bimester seed for January' do
      Timecop.freeze(Date.new(2026, 1, 15))
      expect(described_class.current_period).to eq('2026-01')
    end

    it 'returns the bimester seed for February (still jan-feb bimester)' do
      Timecop.freeze(Date.new(2026, 2, 28))
      expect(described_class.current_period).to eq('2026-01')
    end

    it 'returns the bimester seed for March' do
      Timecop.freeze(Date.new(2026, 3, 1))
      expect(described_class.current_period).to eq('2026-03')
    end

    it 'returns the bimester seed for September' do
      Timecop.freeze(Date.new(2026, 9, 10))
      expect(described_class.current_period).to eq('2026-09')
    end

    it 'returns the bimester seed for December' do
      Timecop.freeze(Date.new(2026, 12, 31))
      expect(described_class.current_period).to eq('2026-11')
    end
  end

  describe '.previous_period' do
    it 'returns the previous bimester for March (-> jan)' do
      Timecop.freeze(Date.new(2026, 3, 15))
      expect(described_class.previous_period).to eq('2026-01')
    end

    it 'returns the previous bimester for September (-> jul)' do
      Timecop.freeze(Date.new(2026, 9, 10))
      expect(described_class.previous_period).to eq('2026-07')
    end

    it 'wraps to previous year for January (-> nov of previous year)' do
      Timecop.freeze(Date.new(2027, 1, 5))
      expect(described_class.previous_period).to eq('2026-11')
    end

    it 'wraps to previous year for February (still jan bimester -> nov of previous year)' do
      Timecop.freeze(Date.new(2027, 2, 10))
      expect(described_class.previous_period).to eq('2026-11')
    end
  end

  describe 'known vectors, duplicated identically in the siade application' do
    before { AdminApientreprise.credentials[described_class::DERIVATION_KEY_CREDENTIAL_KEY] = 'known-vector-derivation-key' }

    after { AdminApientreprise.credentials.delete(described_class::DERIVATION_KEY_CREDENTIAL_KEY) }

    it 'derives the expected password for 2026-11' do
      Timecop.freeze(Date.new(2026, 11, 15))
      expect(described_class.current_password).to eq('2AiKRY3mRq0NERC_')
    end

    it 'derives the expected password for 2027-01' do
      Timecop.freeze(Date.new(2027, 1, 15))
      expect(described_class.current_password).to eq('s-ughRpOLNf6dL7E')
    end

    it 'derives the expected password for 2027-11, whose raw encoding holds no digit' do
      Timecop.freeze(Date.new(2027, 11, 15))
      expect(described_class.current_password).to eq('#Ih0vOaURQyCOMFv')
    end

    it 'only uses special characters allowed by INSEE' do
      Timecop.freeze(Date.new(2026, 11, 15))
      expect(described_class.current_password).to match(/\A[a-zA-Z0-9\-_#]+\z/)
    end

    it 'keeps every character class INSEE requires on every period of the next century' do
      offenders = (2026..2126).flat_map do |year|
        described_class::BIMESTER_MONTHS.filter_map do |month|
          Timecop.freeze(Date.new(year, month, 15))
          next if described_class.current_period < described_class::DERIVATION_START

          password = described_class.current_password

          password unless described_class::CHAR_GUARANTEES.keys.all? { |pattern| password.match?(pattern) }
        end
      end

      expect(offenders).to be_empty
    end
  end

  describe '.current_password' do
    it 'returns the static credential before DERIVATION_START' do
      Timecop.freeze(Date.new(2026, 10, 31))
      expect(described_class.current_password).to eq(static_password)
    end

    it 'returns a derived password at DERIVATION_START' do
      Timecop.freeze(Date.new(2026, 11, 1))
      expect(described_class.current_password).not_to eq(static_password)
    end

    it 'returns a derived password after DERIVATION_START' do
      Timecop.freeze(Date.new(2027, 1, 15))
      expect(described_class.current_password).not_to eq(static_password)
    end
  end

  describe '.previous_password' do
    it 'returns the static credential when the previous period is before DERIVATION_START' do
      Timecop.freeze(Date.new(2026, 11, 15))
      expect(described_class.previous_password).to eq(static_password)
    end

    it 'returns a derived password when the previous period is at or after DERIVATION_START' do
      Timecop.freeze(Date.new(2027, 1, 15))
      expect(described_class.previous_password).not_to eq(static_password)
    end
  end

  describe '.candidates' do
    it 'holds the single static password before DERIVATION_START' do
      Timecop.freeze(Date.new(2026, 9, 15))
      expect(described_class.candidates).to eq([static_password])
    end

    it 'holds the current then the previous password after DERIVATION_START' do
      Timecop.freeze(Date.new(2027, 1, 15))
      expect(described_class.candidates).to eq(
        [described_class.current_password, described_class.previous_password]
      )
    end

    it 'holds two distinct passwords on the first day of derivation' do
      Timecop.freeze(Date.new(2026, 11, 1))
      expect(described_class.candidates).to eq([described_class.current_password, static_password])
    end
  end

  describe 'determinism' do
    it 'produces the same password for the whole bimester' do
      Timecop.freeze(Date.new(2026, 11, 1))
      first_day = described_class.current_password

      Timecop.freeze(Date.new(2026, 12, 20))

      expect(described_class.current_password).to eq(first_day)
    end

    it 'produces different passwords for different periods' do
      Timecop.freeze(Date.new(2026, 11, 1))
      pwd_nov = described_class.current_password

      Timecop.freeze(Date.new(2027, 1, 1))
      pwd_jan = described_class.current_password

      expect(pwd_nov).not_to eq(pwd_jan)
    end
  end

  describe 'password format' do
    before { Timecop.freeze(Date.new(2026, 11, 1)) }

    it 'is 16 characters long' do
      expect(described_class.current_password.length).to eq(16)
    end

    it 'contains at least one uppercase letter' do
      expect(described_class.current_password).to match(/[A-Z]/)
    end

    it 'contains at least one lowercase letter' do
      expect(described_class.current_password).to match(/[a-z]/)
    end

    it 'contains at least one digit' do
      expect(described_class.current_password).to match(/[0-9]/)
    end

    it 'contains at least one special character' do
      expect(described_class.current_password).to match(/[^a-zA-Z0-9]/)
    end
  end

  describe 'bypass credential' do
    let(:bypass_password) { 'ByPass#Password1' }

    before { AdminApientreprise.credentials[described_class::BYPASS_CREDENTIAL_KEY] = bypass_password }

    after { AdminApientreprise.credentials.delete(described_class::BYPASS_CREDENTIAL_KEY) }

    it 'is bypassed' do
      expect(described_class).to be_bypassed
    end

    it 'tries the bypass password first, then the derived current one' do
      Timecop.freeze(Date.new(2027, 1, 15))
      expect(described_class.candidates).to eq([bypass_password, described_class.current_password])
    end

    it 'does not alter the derived passwords' do
      Timecop.freeze(Date.new(2027, 1, 15))
      expect(described_class.current_password).not_to eq(bypass_password)
    end

    context 'when the bypass credential is empty' do
      let(:bypass_password) { '' }

      it 'raises a configuration error' do
        expect { described_class.candidates }.to raise_error(described_class::MissingBypassPasswordError)
      end
    end
  end

  describe '.bypassed?' do
    it 'is false when the credential is absent' do
      expect(described_class).not_to be_bypassed
    end
  end
end
