RSpec.describe Civility::ValidateDateNaissance, type: :validate_param_interactor do
  subject do
    described_class.call(params: {
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:
    })
  end

  let(:annee_date_naissance) { 1980 }
  let(:mois_date_naissance) { 8 }
  let(:jour_date_naissance) { 16 }

  context 'when at least one attribute are missing' do
    context 'when annee_date_naissance is missing' do
      let(:annee_date_naissance) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when mois_date_naissance is missing' do
      let(:mois_date_naissance) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when jour_date_naissance is missing' do
      let(:jour_date_naissance) { nil }

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
      context 'when annee_date_naissance is not valid' do
        let(:annee_date_naissance) { -1980 }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
      end

      context 'when mois_date_naissance is not valid' do
        let(:mois_date_naissance) { 13 }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
      end

      context 'when jour_date_naissance is not valid' do
        let(:jour_date_naissance) { 32 }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
      end
    end

    context 'when date is in the future' do
      let(:annee_date_naissance) { Date.current.year + 1 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when year has more than 4 digits' do
      let(:annee_date_naissance) { 20_214 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when date is before 1900/01/01' do
      let(:annee_date_naissance) { 1899 }
      let(:mois_date_naissance) { 12 }
      let(:jour_date_naissance) { 31 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when date is today' do
      let(:today) { Date.current }
      let(:annee_date_naissance) { today.year }
      let(:mois_date_naissance) { today.month }
      let(:jour_date_naissance) { today.day }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end
  end
end
