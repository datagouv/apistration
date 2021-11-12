RSpec.describe ValidateSiretOrEORI, type: :validate_param_interactor do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        siret_or_eori: siret_or_eori
      }
    end

    context 'when it is a valid EORI' do
      let(:siret_or_eori) { valid_eori }

      it { is_expected.to be_a_success }
    end

    context 'when it is a valid Siret' do
      let(:siret_or_eori) { valid_siret }

      it { is_expected.to be_a_success }
    end

    context 'when it is a valid european EORI' do
      let(:siret_or_eori) { valid_spanish_eori }

      it { is_expected.to be_a_success }
    end

    context 'when it is an invalid siret' do
      let(:siret_or_eori) { invalid_siret }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is nil' do
      let(:siret_or_eori) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is an empty id' do
      let(:siret_or_eori) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is random text' do
      let(:siret_or_eori) { 'random text' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end
  end
end
