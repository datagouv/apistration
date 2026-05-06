RSpec.describe INSEE::PasswordDerivation do
  describe '.current_period' do
    after { Timecop.return }

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
    after { Timecop.return }

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

  describe '.current_password' do
    after { Timecop.return }

    context 'when before DERIVATION_START (2026-09)' do
      it 'returns the static credential' do
        Timecop.freeze(Date.new(2026, 7, 1))
        expect(described_class.current_password).to eq(Siade.credentials[:insee_apim_password])
      end
    end

    context 'when at DERIVATION_START' do
      it 'returns a derived password' do
        Timecop.freeze(Date.new(2026, 9, 1))
        expect(described_class.current_password).not_to eq(Siade.credentials[:insee_apim_password])
      end
    end

    context 'when after DERIVATION_START' do
      it 'returns a derived password' do
        Timecop.freeze(Date.new(2027, 1, 15))
        expect(described_class.current_password).not_to eq(Siade.credentials[:insee_apim_password])
      end
    end
  end

  describe '.previous_password' do
    after { Timecop.return }

    context 'when previous period is before DERIVATION_START' do
      it 'returns the static credential' do
        Timecop.freeze(Date.new(2026, 9, 1))
        expect(described_class.previous_password).to eq(Siade.credentials[:insee_apim_password])
      end
    end

    context 'when previous period is at or after DERIVATION_START' do
      it 'returns a derived password' do
        Timecop.freeze(Date.new(2026, 11, 1))
        expect(described_class.previous_password).not_to eq(Siade.credentials[:insee_apim_password])
      end
    end
  end

  describe 'determinism' do
    after { Timecop.return }

    it 'produces the same password for the same period' do
      Timecop.freeze(Date.new(2026, 10, 1))
      first_call = described_class.current_password
      second_call = described_class.current_password
      expect(first_call).to eq(second_call)
    end

    it 'produces different passwords for different periods' do
      Timecop.freeze(Date.new(2026, 9, 1))
      pwd_sep = described_class.current_password

      Timecop.freeze(Date.new(2026, 11, 1))
      pwd_nov = described_class.current_password

      expect(pwd_sep).not_to eq(pwd_nov)
    end
  end

  describe 'password format' do
    after { Timecop.return }

    before { Timecop.freeze(Date.new(2026, 9, 1)) }

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
end
