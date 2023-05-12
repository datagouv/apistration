RSpec.describe MESRI::Scolarites::ValidateAnneeScolaire, type: :validate_param_interactor do
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

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is nil' do
      let(:annee_scolaire) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is empty' do
      let(:annee_scolaire) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  describe 'Non-regression test: when called in an ValidateParamsOrganizer with wait_to_fail' do
    class DummyOrganizer < ValidateParamsOrganizer
      organize MESRI::Scolarites::ValidateAnneeScolaire
    end

    subject { DummyOrganizer.call(params:) }

    let(:params) do
      {
        annee_scolaire:
      }
    end

    context 'when nil' do
      let(:annee_scolaire) { nil }

      it 'does not fail with NoMethodError' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
