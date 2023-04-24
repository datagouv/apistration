RSpec.describe SIADE::V2::Retrievers::EtablissementsRestored do
  subject(:retriever) { described_class.new(siret).tap(&:retrieve) }

  before { allow_any_instance_of(SIADE::V2::Requests::INSEE::Etablissement).to receive(:insee_token).and_return('not a valid token') }

  describe 'bad siret' do
    let(:siret) { invalid_siret }

    its(:success?) { is_expected.to be_falsey }
    its(:http_code) { is_expected.to eq 422 }
    its(:errors) { is_expected.to have_error(invalid_siret_error_message) }
  end

  describe 'non existent siret', vcr: { cassette_name: 'insee/siret/non_existent' } do
    let(:siret) { non_existent_siret }

    its(:success?) { is_expected.to be_falsey }
    its(:http_code) { is_expected.to eq 404 }
    its(:errors) { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
  end

  describe 'valid siret GE', vcr: { cassette_name: 'insee/siret/active_GE' } do
    let(:siret) { sirets_insee_v3[:active_GE] }
    let(:driver_v3_etab) { SIADE::V2::Drivers::INSEE::Etablissement }

    its(:success?) { is_expected.to be_truthy }

    it { is_expected.to be_delegated_to(driver_v3_etab, :siege_social) }
    it { is_expected.to be_delegated_to(driver_v3_etab, :diffusable_commercialement) }
    it { is_expected.to be_delegated_to(driver_v3_etab, :date_creation) }
    it { is_expected.to be_delegated_to(driver_v3_etab, :etat_administratif) }
    it { is_expected.to be_delegated_to(driver_v3_etab, :date_fermeture) }

    its(:siret_redirected_to_another_siret?) { is_expected.to be false }
    its(:siret) { is_expected.not_to be_nil }
    its(:naf) { is_expected.not_to be_nil }
    its(:libelle_naf) { is_expected.not_to be_nil }
    its(:date_mise_a_jour) { is_expected.not_to be_nil }
    its(:region_implantation) { is_expected.not_to be_nil }
    its(:commune_implantation) { is_expected.not_to be_nil }
    its(:pays_implantation) { is_expected.not_to be_nil }
    its(:diffusable_commercialement?) { is_expected.not_to be_nil }

    its(:l1) { is_expected.not_to be_nil }
    its(:l2) { is_expected.not_to be_nil }
    its(:l4) { is_expected.not_to be_nil }
    its(:l6) { is_expected.not_to be_nil }
    its(:l7) { is_expected.not_to be_nil }
    its(:numero_voie) { is_expected.not_to be_nil }
    its(:type_voie) { is_expected.not_to be_nil }
    its(:nom_voie) { is_expected.not_to be_nil }
    its(:code_postal) { is_expected.not_to be_nil }
    its(:localite) { is_expected.not_to be_nil }
    its(:code_insee_localite) { is_expected.not_to be_nil }
    its(:cedex) { is_expected.not_to be_nil }

    # These are nil with this siret
    its(:enseigne) { is_expected.to be_nil }
    its(:l3) { is_expected.to be_nil }
    its(:l5) { is_expected.to be_nil }
    its(:complement_adresse) { is_expected.to be_nil }

    it 'has valid tranche effectif' do
      tranche_effectif_json = retriever.tranche_effectif_salarie_etablissement
      expect(tranche_effectif_json).to match_json_schema('insee/v3/tranche_effectif_salarie')
    end
  end

  describe 'siret redirected to another siret', vcr: { cassette_name: 'insee/siret/redirected_v2' } do
    let(:siret) { redirected_siret }

    its(:success?) { is_expected.to be_truthy }
    its(:siret_redirected_to_another_siret?) { is_expected.to be true }
    its(:siret) { is_expected.to eq siret }
    its(:redirected_siret) { is_expected.to eq '77887067500015' }
  end
end
