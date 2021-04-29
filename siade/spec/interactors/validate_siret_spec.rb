require 'rails_helper'

RSpec.describe ValidateSiret, type: :interctor do
  describe '#call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        siret: siret,
      }
    end

    context 'when siret is valid' do
      let(:siret) { valid_siret }

      it { is_expected.to be_a_success }
    end

    context 'when siret is not valid' do
      let(:siret) { invalid_siret }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end
  end
end
