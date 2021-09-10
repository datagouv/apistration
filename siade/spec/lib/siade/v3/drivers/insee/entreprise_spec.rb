RSpec.describe SIADE::V3::Drivers::INSEE::Entreprise, type: :provider_driver do
  before { allow_any_instance_of(RenewINSEETokenService).to receive(:current_token_expired?).and_return(false) }

  context 'when siren is not found', vcr: { cassette_name: 'api_insee_fr/siren/non_existent' } do
    subject { described_class.new(siren: siren).tap(&:perform_request) }

    let(:siren) { non_existent_siren }

    its(:http_code) { is_expected.to eq 404 }
  end

  # The following sectionS makes sure ALL fields are correctly mapped with a NON-NULL value
  # active GE: almost all fields
  # active AE: nom, prenoms, sexe
  #
  # remaining untested fields:
  # its(:nom_usage) { is_expected.to be_nil }
  # its(:prenom_4) { is_expected.to be_nil }
  # its(:pseudonyme) { is_expected.to be_nil }

  context 'with an active GE (Grande Entreprise)', vcr: { cassette_name: 'api_insee_fr/siren/active_GE' } do
    subject { @entreprise_active_GE }

    let(:siren) { sirens_insee_v3[:active_GE] }

    before do
      remember_through_each_test_of_current_scope(:entreprise_active_GE) do
        described_class.new(siren: siren).tap(&:perform_request)
      end
    end

    its(:siren) { is_expected.to eq '306138900' }
    its(:nic_siege_social) { is_expected.to eq '01294' }
    its(:siret_siege_social) { is_expected.to eq '30613890001294' }
    its(:date_creation) { is_expected.to eq 220_921_200 }
    its(:date_dernier_traitement) { is_expected.to eq 1_518_476_400 }
    its(:raison_sociale) { is_expected.to eq 'DECATHLON' }
    its(:diffusable_commercialement) { is_expected.to be true }
    its(:sigle) { is_expected.to be_nil }
    its(:etat_administratif) { is_expected.to eq 'A' }
    its(:date_cessation) { is_expected.to be_nil }
    its(:economie_sociale_et_solidaire) { is_expected.to be_nil }
    its(:id_rna) { is_expected.to be_nil }

    its(:sexe) { is_expected.to be_nil }
    its(:nom) { is_expected.to be_nil }
    its(:nom_usage) { is_expected.to be_nil }
    its(:prenom_1) { is_expected.to be_nil }
    its(:prenom_2) { is_expected.to be_nil }
    its(:prenom_3) { is_expected.to be_nil }
    its(:prenom_4) { is_expected.to be_nil }
    its(:prenom_usuel) { is_expected.to be_nil }
    its(:pseudonyme) { is_expected.to be_nil }

    its(:categorie_entreprise) { is_expected.to eq 'GE' }
    its(:annee_categorie_entreprise) { is_expected.to eq '2015' }
    its(:caractere_employeur) { is_expected.to eq 'O' }

    its(:nombre_periodes) { is_expected.to eq 9 }

    describe 'categorie_juridique' do
      subject { @entreprise_active_GE.categorie_juridique }

      its(:code) { is_expected.to eq '5599' }
      its(:libelle) { is_expected.to eq "SA à conseil d'administration (s.a.i.)" }
    end

    describe 'activite_principale' do
      subject { @entreprise_active_GE.activite_principale }

      its(:code) { is_expected.to eq '46.49Z' }
      its(:code_dotless) { is_expected.to eq '4649Z' }
      its(:nomenclature) { is_expected.to eq 'NAFRev2' }
      its(:libelle) { is_expected.to eq "Commerce de gros (commerce interentreprises) d'autres biens domestiques " }
    end

    describe 'tranche_effectif_salarie' do
      subject { @entreprise_active_GE.tranche_effectif_salarie }

      its(:de) { is_expected.to eq 2000 }
      its(:a) { is_expected.to eq 4999 }
      its(:code) { is_expected.to eq '51' }
      its(:date_reference) { is_expected.to eq '2016' }
      its(:intitule) { is_expected.to eq '2 000 à 4 999 salariés' }
    end

    describe 'periode' do
      subject { @entreprise_active_GE.periodes.second }

      its([:date_fin]) { is_expected.to eq 1_403_128_800 }
      its([:date_debut]) { is_expected.to eq 1_403_128_800 }

      it 'have date in correct order' do
        expect(subject[:date_fin]).to be >= subject[:date_debut]
      end

      its([:nom]) { is_expected.to be_nil }
      its([:changement_nom?]) { is_expected.to be false }

      its([:nom_usage]) { is_expected.to be_nil }
      its([:changement_nom_usage?]) { is_expected.to be false }

      its([:raison_sociale]) { is_expected.to eq 'DECATHLON' }
      its([:changement_raison_sociale?]) { is_expected.to be false }

      its([:raison_sociale_usuelle_1]) { is_expected.to eq 'DECATHLON' }
      its([:raison_sociale_usuelle_2]) { is_expected.to be_nil }
      its([:raison_sociale_usuelle_3]) { is_expected.to be_nil }
      its([:changement_raison_sociale_usuelle?]) { is_expected.to be true }

      its([:etat_administratif]) { is_expected.to eq 'A' }
      its([:changement_etat_administratif?]) { is_expected.to be false }

      its([:economie_sociale_et_solidaire]) { is_expected.to be_nil }
      its([:changement_economie_sociale_et_solidaire?]) { is_expected.to be false }

      its([:nic_siege_social]) { is_expected.to eq '01294' }
      its([:changement_nic_siege_social?]) { is_expected.to be false }

      its([:code_forme_juridique]) { is_expected.to eq '5699' }
      its([:changement_forme_juridique?]) { is_expected.to be false }

      its([:caractere_employeur]) { is_expected.to eq 'O' }
      its([:changement_caractere_employeur?]) { is_expected.to be false }

      its([:code_naf]) { is_expected.to eq '46.49Z' }
      its([:nomenclature_naf]) { is_expected.to eq 'NAFRev2' }
      its([:changement_naf?]) { is_expected.to be false }
    end
  end

  context 'with an active AE (Auto-entrepreneur)', vcr: { cassette_name: 'api_insee_fr/siren/active_AE' } do
    subject { @entreprise_active_AE }

    let(:siren) { sirens_insee_v3[:active_AE] }

    before do
      remember_through_each_test_of_current_scope(:entreprise_active_AE) do
        described_class.new(siren: siren).tap(&:perform_request)
      end
    end

    its(:siren) { is_expected.to eq '412288383' }
    its(:nic_siege_social) { is_expected.to eq '00018' }

    its(:sexe) { is_expected.to eq 'F' }
    its(:nom) { is_expected.to eq 'BIDAU' }
    its(:prenom_1) { is_expected.to eq 'ODILE' }
    its(:prenom_2) { is_expected.to eq 'RENEE' }
    its(:prenom_3) { is_expected.to eq 'JANINE' }
    its(:prenom_usuel) { is_expected.to eq 'ODILE' }

    describe 'periode' do
      subject { @entreprise_active_AE.periodes.second }

      its([:nom]) { is_expected.to eq 'BIDAU' }
      its([:changement_nom?]) { is_expected.to be false }
    end
  end

  context 'with another active GE', vcr: { cassette_name: 'api_insee_fr/siren/active_GE_bis' } do
    subject { described_class.new(siren: siren).tap(&:perform_request).periodes.first }

    let(:siren) { sirens_insee_v3[:active_GE_bis] }

    its([:economie_sociale_et_solidaire]) { is_expected.to eq 'N' }
  end

  context 'with an enseigne not null', vcr: { cassette_name: 'api_insee_fr/siren/with_enseigne_siren' } do
    subject { described_class.new(siren: siren).tap(&:perform_request) }

    let(:siren) { sirens_insee_v3[:with_enseigne_siren] }

    its(:sigle) { is_expected.to eq 'GCSPA' }
  end

  context 'which is ceased', vcr: { cassette_name: 'api_insee_fr/siren/ceased' } do
    subject { described_class.new(siren: siren).tap(&:perform_request) }

    let(:siren) { ceased_siren }

    its(:etat_administratif) { is_expected.to eq 'C' }
    its(:date_cessation) { is_expected.to eq 1_315_173_600 }
  end
end
