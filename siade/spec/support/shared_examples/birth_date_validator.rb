RSpec.shared_examples 'a birth date validator' do
  subject(:validation) { described_class.call(params: { annee_date_naissance:, mois_date_naissance:, jour_date_naissance: }) }

  {
    annee_date_naissance: %w[0 8 16],
    mois_date_naissance: %w[1980 13 16],
    jour_date_naissance: %w[1980 8 32],
    date_naissance: %w[1980 2 30]
  }.each do |field, (annee, mois, jour)|
    context "when #{field} is invalid" do
      let(:annee_date_naissance) { annee }
      let(:mois_date_naissance) { mois }
      let(:jour_date_naissance) { jour }

      its('errors.first') { is_expected.to have_attributes(class: UnprocessableEntityError, field:) }
    end
  end
end
