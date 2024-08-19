RSpec.describe Civility::ValidateDateDeNaissance, type: :validate_param_interactor do
  subject do
    described_class.call(params: {
      annee_date_de_naissance:,
      mois_date_de_naissance:,
      jour_date_de_naissance:
    })
  end

  let(:annee_date_de_naissance) { 1980 }
  let(:mois_date_de_naissance) { 8 }
  let(:jour_date_de_naissance) { 16 }

  context 'when at least one attribute are missing' do
    context 'when annee_date_de_naissance is missing' do
      let(:annee_date_de_naissance) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when mois_date_de_naissance is missing' do
      let(:mois_date_de_naissance) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when jour_date_de_naissance is missing' do
      let(:jour_date_de_naissance) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  context 'when all attributes are present' do
    context 'when date is valid' do
      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when one attribute is not valid' do
      context 'when annee_date_de_naissance is not valid' do
        let(:annee_date_de_naissance) { -1980 }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
      end

      context 'when mois_date_de_naissance is not valid' do
        let(:mois_date_de_naissance) { 13 }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
      end

      context 'when jour_date_de_naissance is not valid' do
        let(:jour_date_de_naissance) { 32 }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
      end
    end
  end
end
