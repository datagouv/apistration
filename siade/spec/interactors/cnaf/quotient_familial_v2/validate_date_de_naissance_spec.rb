RSpec.describe CNAF::QuotientFamilialV2::ValidateDateDeNaissance, type: :validate_param_interactor do
  subject do
    described_class.call(params: {
      annee_date_de_naissance:,
      mois_date_de_naissance:,
      jour_date_de_naissance:
    })
  end

  context 'when all attributes are missing' do
    let(:annee_date_de_naissance) { nil }
    let(:mois_date_de_naissance) { nil }
    let(:jour_date_de_naissance) { nil }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when year is present' do
    let(:annee_date_de_naissance) { 1980 }
    let(:mois_date_de_naissance) { nil }
    let(:jour_date_de_naissance) { nil }

    context 'when year is valid' do
      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when year is invalid' do
      let(:annee_date_de_naissance) { -1980 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  context 'when month is present' do
    let(:annee_date_de_naissance) { 1980 }
    let(:mois_date_de_naissance) { 1 }
    let(:jour_date_de_naissance) { nil }

    context 'when year and month is valid' do
      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when year is valid and month is invalid' do
      let(:mois_date_de_naissance) { 13 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when year is absent and month is invalid' do
      let(:annee_date_de_naissance) { nil }
      let(:mois_date_de_naissance) { 13 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  context 'when day month and year are present' do
    let(:annee_date_de_naissance) { 1980 }
    let(:mois_date_de_naissance) { 1 }
    let(:jour_date_de_naissance) { 12 }

    context 'when year, month and day is valid' do
      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when year is absent and month is valid and day invalid' do
      let(:annee_date_de_naissance) { nil }
      let(:mois_date_de_naissance) { 1 }
      let(:jour_date_de_naissance) { 32 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when year, month and day are invalid' do
      let(:annee_date_de_naissance) { 2019 }
      let(:mois_date_de_naissance) { 2 }
      let(:jour_date_de_naissance) { 30 }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end
end
