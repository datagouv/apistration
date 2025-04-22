RSpec.describe DSNJ::ServiceNational::ValidateDateNaissance, type: :validate_param_interactor do
  it 'inherits from Civility::ValidateDateNaissance' do
    expect(described_class).to be < Civility::ValidateDateNaissance
  end

  describe '#call' do
    subject(:result) { described_class.call(params:) }

    context 'with a person exactly 16 years old today' do
      let(:today) { Time.zone.today }

      let(:params) do
        {
          jour_date_naissance: today.day.to_s,
          mois_date_naissance: today.month.to_s,
          annee_date_naissance: (today.year - 16).to_s
        }
      end

      its(:errors) { is_expected.not_to include(instance_of(DSNJError)) }
    end

    context 'with a person turning 16 tomorrow' do
      let(:future_birthday) { Time.zone.today + 1.day }

      let(:params) do
        {
          jour_date_naissance: future_birthday.day.to_s,
          mois_date_naissance: future_birthday.month.to_s,
          annee_date_naissance: (future_birthday.year - 16).to_s
        }
      end

      its(:errors) { is_expected.to include(instance_of(DSNJError)) }
    end

    context 'with a person turning 26 tomorrow' do
      let(:tomorrow) { Time.zone.today + 1.day }

      let(:params) do
        {
          jour_date_naissance: tomorrow.day.to_s,
          mois_date_naissance: tomorrow.month.to_s,
          annee_date_naissance: (tomorrow.year - 26).to_s
        }
      end

      its(:errors) { is_expected.not_to include(instance_of(DSNJError)) }
    end

    context 'with a person who is 26 years old' do
      let(:today) { Time.zone.today }

      let(:params) do
        {
          jour_date_naissance: today.day.to_s,
          mois_date_naissance: today.month.to_s,
          annee_date_naissance: (today.year - 26).to_s
        }
      end

      its(:errors) { is_expected.to include(instance_of(DSNJError)) }
    end
  end
end
