RSpec.describe SIADE::V2::Drivers::INSEE::Etablissement, type: :provider_driver do
  before { allow_any_instance_of(RenewINSEETokenService).to receive(:current_token_expired?).and_return(false) }

  context 'when siret is not found', vcr: { cassette_name: 'api_insee_fr/siret/non_existent' } do
    subject { described_class.new(siret: siret).tap(&:perform_request) }

    let(:siret) { non_existent_siret }

    its(:http_code) { is_expected.to eq 404 }
  end

  # The following sectionS makes sure ALL fields are correctly mapped with a NON-NULL value
  # Grande Entreprise: most fields fields
  # Grande Entreprise Siege social: enseigne, annee_tranche_effectifs
  # Auto-entrepreneur: names, sexe & cie
  # Etranger: commune etranger, complemeent adresse
  # Association: RNA ID
  # Artisan: code activite principale registre metiers
  # with_enseigne_siren : enseigne
  #
  # remaining untested fields
  # its(:sigle) { is_expected.to be_nil }
  # its(:pseudonyme) { is_expected.to be_nil }
  # its(:prenom_4) { is_expected.to be_nil }
  # its(:indice_repetition) { is_expected.to be_nil }
  # its(:distribution_speciale) { is_expected.to be_nil }
  # its(:raison_sociale) { is_expected.to eq '' }

  context 'with an active GE (Grande Entreprise)', vcr: { cassette_name: 'api_insee_fr/siret/active_GE' } do
    subject { @etab_active_GE }

    let(:siret) { sirets_insee_v3[:active_GE] }

    before do
      remember_through_each_test_of_current_scope(:etab_active_GE) do
        described_class.new(siret: siret).tap(&:perform_request)
      end
    end

    its(:siret_redirected_to_another_siret?) { is_expected.to be false }
    its(:siege_social) { is_expected.to be false }
    its(:siren) { is_expected.to eq '306138900' }
    its(:nic) { is_expected.to eq '02979' }
    its(:siret) { is_expected.to eq '30613890002979' }
    its(:raison_sociale) { is_expected.to be_nil }
    its(:etat_administratif) { is_expected.to eq 'A' }
    its(:date_fermeture) { is_expected.to be_nil }
    its(:date_dernier_traitement) { is_expected.to eq 1_271_541_600 }
    its(:diffusable_commercialement) { is_expected.to be true }
    its(:date_creation) { is_expected.to eq 1_085_522_400 }
    its(:enseigne_1) { is_expected.to be_nil }
    its(:activite_princiaple_registre_metiers) { is_expected.to be_nil }
    its(:caractere_employeur) { is_expected.to eq 'O' }
    its(:nombre_periodes_etablissement) { is_expected.to eq 3 }

    describe 'activite_principale' do
      subject { @etab_active_GE.activite_principale }

      its(:code) { is_expected.to eq '47.64Z' }
      its(:code_dotless) { is_expected.to eq '4764Z' }
      its(:nomenclature) { is_expected.to eq 'NAFRev2' }
      its(:libelle) { is_expected.to eq "Commerce de détail d'articles de sport en magasin spécialisé" }
    end

    describe 'tranche_effectif_salarie' do
      subject { @etab_active_GE.tranche_effectif_salarie }

      its(:de) { is_expected.to be_nil }
      its(:a) { is_expected.to be_nil }
      its(:code) { is_expected.to eq 'NN' }
      its(:date_reference) { is_expected.to be_nil }
      its(:intitule) { is_expected.to eq 'Unités non employeuses' }
    end

    describe 'periodes_etablissment' do
      subject { @etab_active_GE.periodes_etablissement.second }

      its([:date_fin]) { is_expected.to eq 1_199_055_600 }
      its([:date_debut]) { is_expected.to eq 1_103_929_200 }

      it 'have date in correct order' do
        expect(subject[:date_fin]).to be > subject[:date_debut]
      end

      its([:etat_administratif]) { is_expected.to eq 'A' }
      its([:changement_etat_administratif?]) { is_expected.to be false }

      its([:enseigne_1]) { is_expected.to be_nil }
      its([:enseigne_2]) { is_expected.to be_nil }
      its([:enseigne_3]) { is_expected.to be_nil }
      its([:changement_enseigne?]) { is_expected.to be false }

      its([:caractere_employeur]) { is_expected.to eq 'O' }
      its([:changement_caractere_employeur?]) { is_expected.to be true }

      its([:code_naf]) { is_expected.to eq '52.4W' }
      its([:nomenclature_naf]) { is_expected.to eq 'NAFRev1' }
      its([:changement_naf?]) { is_expected.to be true }
    end

    describe 'adresse' do
      subject { @etab_active_GE.adresse }

      its([:adresse_francaise?]) { is_expected.to be true }
      its([:complement_adresse]) { is_expected.to be_nil }
      its([:numero_voie]) { is_expected.to eq '330' }
      its([:indice_repetition]) { is_expected.to be_nil }
      its([:type_voie]) { is_expected.to eq 'AV' }
      its([:libelle_voie]) { is_expected.to eq 'MARCOU DELANGLADE' }
      its([:code_postal]) { is_expected.to eq '84140' }
      its([:code_commune]) { is_expected.to eq '84007' }
      its([:libelle_commune]) { is_expected.to eq 'AVIGNON' }
      its([:libelle_commune_etranger]) { is_expected.to be_nil }
      its([:distribution_speciale]) { is_expected.to be_nil }
      its([:code_cedex]) { is_expected.to eq '84014' }
      its([:libelle_cedex]) { is_expected.to eq 'AVIGNON CEDEX 1' }
      its([:code_pays_etranger]) { is_expected.to be_nil }
      its([:libelle_code_pays_etranger]) { is_expected.to be_nil }
    end

    describe 'entreprise' do
      subject { @etab_active_GE.entreprise }

      its([:nic_siege_social]) { is_expected.to eq '01294' }
      its([:raison_sociale]) { is_expected.to eq 'DECATHLON' }
      its([:sigle]) { is_expected.to be_nil }
      its([:etat_administratif]) { is_expected.to eq 'A' }
      its([:diffusable_commercialement?]) { is_expected.to be true }
      its([:date_creation]) { is_expected.to eq 220_921_200 }
      its([:date_dernier_traitement]) { is_expected.to eq 1_518_476_400 }

      its([:sexe]) { is_expected.to be_nil }
      its([:nom]) { is_expected.to be_nil }
      its([:nom_usage]) { is_expected.to be_nil }
      its([:prenom_1]) { is_expected.to be_nil }
      its([:prenom_2]) { is_expected.to be_nil }
      its([:prenom_3]) { is_expected.to be_nil }
      its([:prenom_4]) { is_expected.to be_nil }
      its([:prenom_usuel]) { is_expected.to be_nil }
      its([:pseudonyme]) { is_expected.to be_nil }

      its([:raison_sociale_usuelle_1]) { is_expected.to eq 'DECATHLON' }
      its([:raison_sociale_usuelle_2]) { is_expected.to be_nil }
      its([:raison_sociale_usuelle_3]) { is_expected.to be_nil }

      its([:id_rna]) { is_expected.to be_nil }
      its([:economie_sociale_et_solidaire]) { is_expected.to be_nil }
      its([:caractere_employeur]) { is_expected.to eq 'O' }

      its([:code_forme_juridique]) { is_expected.to eq '5599' }
      its([:code_naf]) { is_expected.to eq '46.49Z' }

      its([:code_tranche_effectif_salarie]) { is_expected.to eq '51' }
      its([:annee_tranche_effectif_salarie]) { is_expected.to eq '2016' }

      its([:categorie_entreprise]) { is_expected.to eq 'GE' }
      its([:annee_categorie_entreprise]) { is_expected.to eq '2015' }
    end
  end

  context 'with an active GE: Siege social', vcr: { cassette_name: 'api_insee_fr/siret/active_GE_ss' } do
    subject { @etab_active_GE_ss }

    let(:siret) { sirets_insee_v3[:active_GE_ss] }

    before do
      remember_through_each_test_of_current_scope(:etab_active_GE_ss) do
        described_class.new(siret: siret).tap(&:perform_request)
      end
    end

    its(:siege_social) { is_expected.to be true }

    describe 'tranche_effectif_salarie' do
      subject { @etab_active_GE_ss.tranche_effectif_salarie }

      its(:de) { is_expected.to eq 250 }
      its(:a) { is_expected.to eq 499 }
      its(:code) { is_expected.to eq '32' }
      its(:date_reference) { is_expected.to eq '2016' }
      its(:intitule) { is_expected.to eq '250 à 499 salariés' }
    end

    describe 'periodes_etablissment' do
      subject { @etab_active_GE_ss.periodes_etablissement.first }

      its([:enseigne_1]) { is_expected.to eq 'DECATHLON DIRECTION GENERALE FRANCE' }
      its([:changement_enseigne?]) { is_expected.to be true }
    end

    describe 'entreprise' do
      subject { @etab_active_GE_ss.entreprise }

      its([:economie_sociale_et_solidaire]) { is_expected.to eq 'N' }
    end
  end

  context 'with an active AE (Auto-entrepreneur)', vcr: { cassette_name: 'api_insee_fr/siret/active_AE' } do
    subject { @etab_active_AE }

    let(:siret) { sirets_insee_v3[:active_AE] }

    before do
      remember_through_each_test_of_current_scope(:etab_active_AE) do
        described_class.new(siret: siret).tap(&:perform_request)
      end
    end

    its(:siege_social) { is_expected.to be true }

    describe 'entreprise' do
      subject { @etab_active_AE.entreprise }

      its([:sexe]) { is_expected.to eq 'F' }
      its([:nom]) { is_expected.to eq 'BIDAU' }
      its([:nom_usage]) { is_expected.to eq 'BAROIN' }
      its([:prenom_1]) { is_expected.to eq 'ODILE' }
      its([:prenom_2]) { is_expected.to eq 'RENEE' }
      its([:prenom_3]) { is_expected.to eq 'JANINE' }
      its([:prenom_usuel]) { is_expected.to eq 'ODILE' }
    end
  end

  describe 'with siret etranger', vcr: { cassette_name: 'api_insee_fr/siret/etranger_1' } do
    subject { described_class.new(siret: siret).tap(&:perform_request).adresse }

    let(:siret) { sirets_insee_v3[:etranger_1] }

    its([:adresse_francaise?]) { is_expected.to be false }
    its([:complement_adresse]) { is_expected.to eq 'SUITE 331 KEMP HOUSE' }
    its([:libelle_commune_etranger]) { is_expected.to eq 'LONDRES' }

    its([:code_pays_etranger]) { is_expected.to eq '99132' }
    its([:libelle_pays_etranger]) { is_expected.to eq 'ROYAUME-UNI' }
  end

  describe 'with Association', vcr: { cassette_name: 'api_insee_fr/siret/active_association' } do
    subject { described_class.new(siret: siret).tap(&:perform_request).entreprise }

    let(:siret) { sirets_insee_v3[:active_association] }

    its([:id_rna]) { is_expected.to eq 'W912007752' }
  end

  describe 'with an artisan', vcr: { cassette_name: 'api_insee_fr/siret/artisan' } do
    subject { described_class.new(siret: siret).tap(&:perform_request) }

    let(:siret) { sirets_insee_v3[:artisan] }

    its(:activite_princiaple_registre_metiers) { is_expected.to eq '4332AA' }
  end

  describe 'with enseigne', vcr: { cassette_name: 'api_insee_fr/siret/with_enseigne_siret' } do
    subject { described_class.new(siret: siret).tap(&:perform_request) }

    let(:siret) { sirets_insee_v3[:with_enseigne_siret] }

    its(:enseignes) { is_expected.to eq 'DOMAINE DAVID BIENFAIT' }
  end

  describe 'which is closed', vcr: { cassette_name: 'api_insee_fr/siret/closed' } do
    subject { described_class.new(siret: siret).tap(&:perform_request) }

    let(:siret) { closed_siret }

    its(:etat_administratif) { is_expected.to eq 'F' }
    its(:date_fermeture) { is_expected.to eq 1_315_173_600 }
  end

  describe 'siret redirected to another siret', vcr: { cassette_name: 'api_insee_fr/siret/redirected' } do
    subject { described_class.new(siret: siret).tap(&:perform_request) }

    let(:siret) { redirected_siret }

    its(:siret_redirected_to_another_siret?) { is_expected.to be true }
    its(:siret) { is_expected.to eq '77887067500015' }
  end
end
