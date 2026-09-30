RSpec.describe PersonalDataAnonymizer do
  describe '.email' do
    it 'replaces the email with a yopmail address derived from it' do
      expect(described_class.email('jean.dupont@example.gouv.fr')).to match(/\Aanon-\h{12}@yopmail\.com\z/)
    end

    it 'derives the same address whatever the case and surrounding spaces' do
      expect(described_class.email(' Jean.Dupont@Example.gouv.fr ')).to eq(described_class.email('jean.dupont@example.gouv.fr'))
    end

    it 'derives different addresses for different emails' do
      expect(described_class.email('jean@example.fr')).not_to eq(described_class.email('paul@example.fr'))
    end

    it 'keeps yopmail addresses, which are public test inboxes' do
      expect(described_class.email('Hunter-YWHADMIN@yopmail.com')).to eq('hunter-ywhadmin@yopmail.com')
    end

    it 'is idempotent' do
      anonymized_email = described_class.email('jean.dupont@example.gouv.fr')

      expect(described_class.email(anonymized_email)).to eq(anonymized_email)
    end

    it 'returns blank values untouched' do
      expect(described_class.email(nil)).to be_nil
      expect(described_class.email('')).to eq('')
    end
  end

  describe '.first_name and .last_name' do
    it 'replaces the name with a label and a suffix derived from it' do
      expect(described_class.first_name('Jean')).to match(/\APrénom \h{6}\z/)
      expect(described_class.last_name('Dupont')).to match(/\ANom \h{6}\z/)
    end

    it 'is idempotent' do
      anonymized_first_name = described_class.first_name('Jean')
      anonymized_last_name = described_class.last_name('Dupont')

      expect(described_class.first_name(anonymized_first_name)).to eq(anonymized_first_name)
      expect(described_class.last_name(anonymized_last_name)).to eq(anonymized_last_name)
    end

    it 'returns blank values untouched' do
      expect(described_class.first_name(nil)).to be_nil
    end
  end

  describe '.phone' do
    it 'replaces the phone number with a fake one' do
      expect(described_class.phone('06 12 34 56 78')).to eq('0100000000')
    end

    it 'returns blank values untouched' do
      expect(described_class.phone('')).to eq('')
    end
  end
end
