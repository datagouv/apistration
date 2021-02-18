require 'rails_helper'

RSpec.describe ValidateSiren, type: :interctor do
  describe '#call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        siren: siren,
      }
    end

    context 'when siren is valid' do
      let(:siren) { valid_siren }

      it { is_expected.to be_a_success }
    end

    context 'when siren is not valid' do
      let(:siren) { invalid_siren }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
      its(:status) { is_expected.to eq(422) }
    end
  end
end
