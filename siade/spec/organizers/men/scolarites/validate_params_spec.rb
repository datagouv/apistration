RSpec.describe MEN::Scolarites::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      nom_naissance:,
      prenoms:,
      sexe_etat_civil:,
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:,
      code_etablissement:,
      annee_scolaire:,
      degre_etablissement:,
      codes_bcn_departements:,
      codes_bcn_regions:
    }
  end

  let(:nom_naissance) { 'Dupont' }
  let(:prenoms) { ['Jean'] }
  let(:sexe_etat_civil) { 'm' }
  let(:annee_date_naissance) { '2000' }
  let(:mois_date_naissance) { '01' }
  let(:jour_date_naissance) { '01' }
  let(:code_etablissement) { '1234567w' }
  let(:annee_scolaire) { '2022' }
  let(:degre_etablissement) { nil }
  let(:codes_bcn_departements) { nil }
  let(:codes_bcn_regions) { nil }

  context 'with code_etablissement mode' do
    context 'with valid attributes' do
      it { is_expected.to be_a_success }
    end

    context 'with missing nom_naissance' do
      let(:nom_naissance) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'without prenoms' do
      let(:prenoms) { [] }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'without code_etablissement' do
      let(:code_etablissement) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with invalid annee_scolaire' do
      let(:annee_scolaire) { 'lol' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with invalid sexe_etat_civil' do
      let(:sexe_etat_civil) { 'lol' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with invalid jour_date_naissance' do
      let(:jour_date_naissance) { 'lol' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  context 'with perimetre mode' do
    let(:code_etablissement) { nil }
    let(:degre_etablissement) { '2D' }
    let(:codes_bcn_regions) { %w[11] }

    context 'with valid attributes' do
      it { is_expected.to be_a_success }
    end

    context 'with invalid degre_etablissement' do
      let(:degre_etablissement) { '3D' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with no perimetre' do
      let(:codes_bcn_regions) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with multiple perimetres' do
      let(:codes_bcn_departements) { %w[075] }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  context 'with both code_etablissement and perimetre' do
    let(:code_etablissement) { '1234567w' }
    let(:codes_bcn_regions) { %w[11] }

    it { is_expected.to be_a_failure }

    it 'returns mutual exclusivity error' do
      error = subject.errors.find { |e| e.code == '00419' }
      expect(error).to be_present
    end
  end
end
