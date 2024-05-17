RSpec.describe CNAV::QuotientFamilialV2::ValidateMonth, type: :validate_param_interactor do
  before do
    Timecop.freeze(Time.zone.local(2021, 10, 25))
  end

  after do
    Timecop.return
  end

  describe '#call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        mois:,
        annee:
      }
    end

    let(:annee) { 2021 }

    context 'when mois is valid' do
      let(:mois) { 2 }

      it { is_expected.to be_a_success }
    end

    context 'when mois is not valid' do
      let(:mois) { 13 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when mois is bigger, in the past' do
      let(:mois) { 11 }
      let(:annee) { 2020 }

      it { is_expected.to be_a_success }
    end

    context 'when mois is bigger, with no year' do
      let(:mois) { 11 }
      let(:annee) { nil }

      it { is_expected.to be_a_success }
    end

    context 'when mois is bigger, in the future' do
      let(:mois) { 11 }
      let(:annee) { 2021 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end
  end
end
