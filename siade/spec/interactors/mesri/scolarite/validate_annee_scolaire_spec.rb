RSpec.describe MESRI::Scolarite::ValidateAnneeScolaire, type: :validate_param_interactor do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        annee_scolaire:
      }
    end

    context 'when valid with short format' do
      let(:annee_scolaire) { '2013' }

      it { is_expected.to be_a_success }
    end

    context 'when valid with long format' do
      let(:annee_scolaire) { '2014-2015' }

      it { is_expected.to be_a_success }
    end

    context 'when invalid' do
      let(:annee_scolaire) { '2014_2015' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is nil' do
      let(:annee_scolaire) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is empty' do
      let(:annee_scolaire) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end
  end
end
