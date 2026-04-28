RSpec.describe CNOUS::ValidateCampaignYear, type: :validate_param_interactor do
  subject { described_class.call(params:) }

  around do |example|
    Timecop.freeze(Date.new(2026, 4, 27)) { example.run }
  end

  let(:params) { { campaign_year: } }

  context 'when campaign_year is missing' do
    let(:campaign_year) { nil }

    it { is_expected.to be_a_success }
  end

  context 'when campaign_year is blank' do
    let(:campaign_year) { '' }

    it { is_expected.to be_a_success }
  end

  context 'when campaign_year is below the minimum' do
    let(:campaign_year) { '2020' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when campaign_year equals the minimum (2021)' do
    let(:campaign_year) { '2021' }

    it { is_expected.to be_a_success }
  end

  context 'when campaign_year equals current year - 1' do
    let(:campaign_year) { '2025' }

    it { is_expected.to be_a_success }
  end

  context 'when campaign_year equals current year' do
    let(:campaign_year) { '2026' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when campaign_year is not a 4-digit string' do
    let(:campaign_year) { '20a4' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when campaign_year is an integer in range' do
    let(:campaign_year) { 2024 }

    it { is_expected.to be_a_success }
  end
end
