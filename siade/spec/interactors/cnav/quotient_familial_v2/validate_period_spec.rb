RSpec.describe CNAV::QuotientFamilialV2::ValidatePeriod, type: :validate_param_interactor do
  subject { described_class.call(params:) }

  before do
    Timecop.freeze(Time.zone.local(2026, 9, 10))
  end

  after do
    Timecop.return
  end

  let(:params) { { annee:, mois: }.compact }

  context 'without period' do
    let(:annee) { nil }
    let(:mois) { nil }

    it { is_expected.to be_a_success }
  end

  context 'with the current month' do
    let(:annee) { 2026 }
    let(:mois) { 9 }

    it { is_expected.to be_a_success }
  end

  context 'with the oldest month served by the CAF, 23 months ago' do
    let(:annee) { 2024 }
    let(:mois) { 10 }

    it { is_expected.to be_a_success }
  end

  context 'with a month older than 23 months' do
    let(:annee) { 2024 }
    let(:mois) { 9 }

    it { is_expected.to be_a_failure }

    it 'rejects the period with its own code' do
      expect(subject.errors.first).to be_a(UnprocessableEntityError)
      expect(subject.errors.first.code).to eq('00355')
    end
  end

  context 'with a year only, resolved on the current month' do
    let(:mois) { nil }

    context 'when that month is within the window' do
      let(:annee) { 2025 }

      it { is_expected.to be_a_success }
    end

    context 'when that month is beyond the window' do
      let(:annee) { 2024 }

      it { is_expected.to be_a_failure }
    end
  end

  context 'with a month only, resolved on the current year' do
    let(:annee) { nil }
    let(:mois) { 1 }

    it { is_expected.to be_a_success }
  end

  context 'with a year already rejected upstream' do
    let(:annee) { 'lol' }
    let(:mois) { 1 }

    it { is_expected.to be_a_success }
  end
end
