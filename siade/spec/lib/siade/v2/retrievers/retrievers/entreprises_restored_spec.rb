RSpec.describe SIADE::V2::Retrievers::EntreprisesRestored do
  subject(:retriever) { described_class.new(siren).tap(&:retrieve) }

  before { allow_any_instance_of(SIADE::V2::Requests::INSEE::Entreprise).to receive(:insee_token).and_return('not a valid token') }

  describe 'bad siren' do
    let(:siren) { invalid_siren }

    its(:success?) { is_expected.to be_falsey }
    its(:http_code) { is_expected.to eq 422 }
    its(:errors) { is_expected.to have_error(invalid_siren_error_message) }
  end

  describe 'non existent siren', vcr: { cassette_name: 'insee/siren/non_existent' } do
    let(:siren) { non_existent_siren }

    its(:success?) { is_expected.to be_falsey }
    its(:http_code) { is_expected.to eq 404 }
    its(:errors) { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
  end

  describe 'valid siren GE', vcr: { cassette_name: 'insee/siren/active_GE' } do
    let(:siren) { sirens_insee_v3[:active_GE] }
    let(:driver_v3_ent) { SIADE::V2::Drivers::INSEE::Entreprise }
    let(:driver_infogreffe) { SIADE::V2::Drivers::Infogreffe }

    its(:success?) { is_expected.to be_truthy }

    it { is_expected.to be_delegated_to(driver_infogreffe, :nom_commercial) }
    it { is_expected.to be_delegated_to(driver_infogreffe, :date_radiation) }
    it { is_expected.to be_delegated_to(driver_infogreffe, :capital_social) }
    it { is_expected.to be_delegated_to(driver_infogreffe, :mandataires_sociaux) }

    it { is_expected.to be_delegated_to(driver_v3_ent, :categorie_juridique) }
    it { is_expected.to be_delegated_to(driver_v3_ent, :sigle) }
    it { is_expected.to be_delegated_to(driver_v3_ent, :activite_principale) }
    it { is_expected.to be_delegated_to(driver_v3_ent, :siret_siege_social) }
    it { is_expected.to be_delegated_to(driver_v3_ent, :tranche_effectif_salarie) }
    it { is_expected.to be_delegated_to(driver_v3_ent, :date_creation) }
    it { is_expected.to be_delegated_to(driver_v3_ent, :nom) }
    it { is_expected.to be_delegated_to(driver_v3_ent, :nom_usage) }
    it { is_expected.to be_delegated_to(driver_v3_ent, :prenom_1) }
    it { is_expected.to be_delegated_to(driver_v3_ent, :prenom_2) }
    it { is_expected.to be_delegated_to(driver_v3_ent, :prenom_3) }
    it { is_expected.to be_delegated_to(driver_v3_ent, :date_cessation) }
    it { is_expected.to be_delegated_to(driver_v3_ent, :diffusable_commercialement) }
    it { is_expected.to be_delegated_to(driver_v3_ent, :categorie_entreprise) }

    its(:siren) { is_expected.not_to be_nil }
    its(:raison_sociale) { is_expected.not_to be_nil }
    its(:tranche_effectif_salarie_entreprise) { is_expected.to be_a(Hash) }
    its(:procedure_collective) { is_expected.not_to be_nil }
    its(:etat_administratif) { is_expected.to be_a(Hash) }
    its(:diffusable_commercialement) { is_expected.to be_in([true, false]) }
    its(:forme_juridique) { is_expected.not_to be_nil }
    its(:forme_juridique_code) { is_expected.not_to be_nil }
    its(:libelle_naf) { is_expected.not_to be_nil }
    its(:naf) { is_expected.not_to be_nil }
    its(:code_effectif_entreprise) { is_expected.not_to be_nil }
    its(:numero_tva_intracommunautaire) { is_expected.not_to be_nil }
    its(:diffusable_commercialement?) { is_expected.not_to be_nil }

    # These are nil with this siren
    its(:prenom) { is_expected.to be_nil }
    its(:enseigne) { is_expected.to be_nil }
  end
end
