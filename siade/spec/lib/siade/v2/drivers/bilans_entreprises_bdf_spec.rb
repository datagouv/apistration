RSpec.describe SIADE::V2::Drivers::BilansEntreprisesBDF, type: :provider_driver do

  context 'Siren does not exist', vcr: { cassette_name: 'bilan_entreprise_bdf_non_existent_siren' }  do

    subject do
      d = described_class.new({ siren: non_existent_siren })
      d.perform_request
      d
    end

    its(:http_code) { is_expected.to eq(404) }
  end

  #XXX TODO REFACTOR how do we handle json / xml / whatever parsing errors accross app
  context 'Handle well parsing error'

  context 'bad formated siren' do
    let(:siren) { invalid_siren }

    subject do
      d = described_class.new({ siren: invalid_siren})
      d.perform_request
      d
    end

    its(:http_code) { is_expected.to eq 422 }
    its(:errors)    { is_expected.to have_error(invalid_siren_error_message) }
  end

  context 'well formated valid siren with information', vcr: { cassette_name: 'bilan_entreprise_bdf_valid_siren' } do
    let(:siren) { valid_siren(:bilan_entreprise_bdf) }

    before do
      remember_through_each_test_of_current_scope('bilan_entreprise_bdf_valid_siren') do
        d = described_class.new(siren: valid_siren(:bilan_entreprise_bdf))
        d.perform_request
        d
      end
    end

    subject { @bilan_entreprise_bdf_valid_siren }

    its(:http_code) { is_expected.to eq 200 }
    its(:errors)    { is_expected.to be_empty }

    its(:monnaie) { is_expected.to eq('kEuros') }

    its(:bilans)  { is_expected.to be_a_kind_of Array }

    context '#bilans' do
      subject     { super().bilans }

      its(:size)  { is_expected.to eq(3) }
      its(:first) { is_expected.to be_a_kind_of Hash }

      context '#first' do
        subject { super().first }

        its(['besoin_en_fonds_de_roulement']) { is_expected.to eq("-589690") }
        its(['chiffre_affaires_ht']) { is_expected.to eq("11745843") }
        its(['capacite_autofinancement']) { is_expected.to eq("731329") }
        its(['date_arret_exercice']) { is_expected.to eq("201712") }
        its(['dettes1_emprunts_obligataires_et_convertibles']) { is_expected.to eq("0") }
        its(['dettes2_autres_emprunts_obligataires']) { is_expected.to eq("5123959") }
        its(['dettes3_emprunts_et_dettes_aupres_des_etablissements_de_credit']) { is_expected.to eq("0") }
        its(['dettes4_maturite_a_un_an_au_plus']) { is_expected.to eq("0") }
        its(['disponibilites']) { is_expected.to eq("1542848") }


        # XXX pas clair que c'est un dont ça a pas l'air onclus dans les fonds propres et assimiles
        its(['autres_fonds_propres']) { is_expected.to eq("0") }
        its(['capitaux_propres_et_assimiles']) { is_expected.to eq("6484777") }
        its(['capital_social_inclus_dans_capitaux_propres_et_assimiles']) { is_expected.to eq("3800000") }
        its(['duree_exercice']) { is_expected.to eq("12") }
        its(['excedent_brut_exploitation']) { is_expected.to eq("-2111608") }
        its(['emprunts_et_dettes_financieres_divers']) { is_expected.to eq("972491") }
        its(['evolution_besoin_en_fonds_de_roulement']) { is_expected.to eq("-4,17%") }
        its(['evolution_chiffre_affaires_ht']) { is_expected.to eq("-1,15%") }
        its(['evolution_capacite_autofinancement']) { is_expected.to eq("-8,16%") }
        its(['evolution_capitaux_propres_et_assimiles']) { is_expected.to eq("+7,75%") }
        its(['evolution_dettes1_emprunts_obligataires_et_convertibles']) { is_expected.to eq("") }
        its(['evolution_dettes2_autres_emprunts_obligataires']) { is_expected.to eq("-10,73%") }
        its(['evolution_dettes3_emprunts_et_dettes_aupres_des_etablissements_de_credit']) { is_expected.to eq("") }
        its(['evolution_dettes4_maturite_a_un_an_au_plus']) { is_expected.to eq("") }
        its(['evolution_disponibilites']) { is_expected.to eq("-20,28%") }
        its(['evolution_autres_fonds_propres']) { is_expected.to eq("") }
        its(['evolution_capital_social_inclus_dans_capitaux_propres_et_assimiles']) { is_expected.to eq("0,00%") }
        its(['evolution_excedent_brut_exploitation']) { is_expected.to eq("-6,17%") }
        its(['evolution_emprunts_et_dettes_financieres_divers']) { is_expected.to eq("+19,26%") }
        its(['evolution_fonds_roulement_net_global']) { is_expected.to eq("-25,98%") }
        its(['evolution_ratio_fonds_roulement_net_global_sur_besoin_en_fonds_de_roulement']) { is_expected.to eq("") }
        its(['evolution_groupes_et_associes']) { is_expected.to eq("") }
        its(['evolution_resultat_exercice']) { is_expected.to eq("+134,49%") }
        its(['evolution_total_passif']) { is_expected.to eq("-2,45%") }
        its(['evolution_total_provisions_pour_risques_et_charges']) { is_expected.to eq("-11,09%") }
        its(['evolution_total_dettes_stables']) { is_expected.to eq("-10,73%") }
        its(['evolution_valeur_ajoutee_bdf']) { is_expected.to eq("-3,94%") }
        its(['fonds_roulement_net_global']) { is_expected.to eq("1572300") }
        its(['ratio_fonds_roulement_net_global_sur_besoin_en_fonds_de_roulement']) { is_expected.to eq("-") }
        its(['groupes_et_associes']) { is_expected.to eq("0") }
        its(['resultat_exercice']) { is_expected.to eq("658911") }
        its(['total_dettes_stables']) { is_expected.to eq("5123959") }
        its(['total_passif']) { is_expected.to eq("17822290") }
        its(['total_provisions_pour_risques_et_charges']) { is_expected.to eq("1882196") }
        its(['valeur_ajoutee_bdf']) { is_expected.to eq("7234669") }
      end
    end
  end
end
