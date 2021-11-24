RSpec.describe DGFIP::LiassesFiscales::ValidateParams, type: :validate_params do
  subject { described_class.call(params: params) }

  let(:params) do
    {
      siren: siren,
      year: year
    }
  end

  let(:siren) { valid_siren }
  let(:year) { (Time.zone.today.year - 2).to_s }

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
  end

  context 'with invalid year' do
    let(:year) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid siren' do
    let(:siren) { '1234567890' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
