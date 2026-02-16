class BanqueDeFrance::BilansEntreprise::BuildResourceCollectionWithoutDictionaries < BuildResourceCollection
  protected

  def items
    valid_bilans
  end

  def items_context
    {
      count: valid_bilans.count
    }
  end

  def resource_attributes(item)
    clean_item!(item)

    {
      annee: item['dateArrete'][0..3],
      date_arrete_exercice: "#{item['dateArrete'][0..3]}-#{item['dateArrete'][4..5]}",
      declarations: [
        {
          numero_imprime: '2051',
          donnees: [
            build_declaration_data('300476', 'totalPassif', item),
            build_declaration_data('300438', 'capitauxPropresEtAssimiles', item),
            build_declaration_data('300414', 'dontCapitalSocial', item),
            build_declaration_data('302359', 'totalProvisionsPourRisquesEtCharges', item),
            build_declaration_data('300451', 'dettes1EmpruntsObligatairesEtConvertibles', item),
            build_declaration_data('300453', 'dettes2AutresEmpruntsObligataires', item),
            build_declaration_data('300455', 'dettes3EmpruntsEtDettesAupresDesEtablissementsdeCredit', item),
            build_declaration_data('300458', 'empruntsEtDettesFinancieresDivers', item)
          ]
        },
        {
          numero_imprime: '2052',
          donnees: [
            build_declaration_data('300506', 'caHT', item)
          ]
        },
        {
          numero_imprime: '2053',
          donnees: [
            build_declaration_data('300606', 'resultatExercice', item)
          ]
        },
        {
          numero_imprime: '2057',
          donnees: [
            build_declaration_data('301195', 'groupesEtAssocies', item)
          ]
        }
      ],
      valeurs_calculees: [
        { disponibilites: {
            valeur: convert_to_euros(item['disponibilites']),
            evolution: build_percent(item['evolutionDisponibilites'])
          },
          total_dettes_stables: {
            valeur: convert_to_euros(item['totalDettesStables']),
            evolution: build_percent(item['evolutionTotaltotalDettesStables'])
          },
          valeur_ajoutee_bdf: {
            valeur: convert_to_euros(item['valeurAjouteeBdf']),
            evolution: build_percent(item['evolutionValeurAjouteeBdf'])
          },
          besoin_en_fonds_de_roulement: {
            valeur: convert_to_euros(item['besoinEnFondsDeRoulement']),
            evolution: build_percent(item['evolutionBesoinEnFondsDeRoulement'])
          },
          excedent_brut_exploitation: {
            valeur: convert_to_euros(item['ebe']),
            evolution: build_percent(item['evolutionEbe'])
          },
          capacite_autofinancement: {
            valeur: convert_to_euros(item['caf']),
            evolution: build_percent(item['evolutionCaf'])
          },
          fonds_roulement_net_global: {
            valeur: convert_to_euros(item['frng']),
            evolution: build_percent(item['evolutionFrng'])
          },
          ratio_fonds_roulement_net_global_sur_besoin_en_fonds_de_roulement: {
            valeur: build_percent(item['frng/bfr']),
            evolution: build_percent(item['evolutionFrng/Bfr'])
          },
          dettes4_maturite_a_un_an_au_plus: {
            valeur: convert_to_euros(item['dettes4DontAUnAnAuPlus']),
            evolution: build_percent(item['evolutionDettes4DontAUnAnAuPlus'])
          } }
      ]
    }
  end

  private

  def valid_bilans
    json_body['bilans'].reject do |bilan_payload|
      bilan_payload['duree_exercice'] == '-'
    end
  end

  def build_declaration_data(code_nref, key, item)
    {
      code_nref:,
      valeurs: [
        convert_to_euros(item.fetch(key))
      ],
      evolution: build_percent(item.fetch("evolution#{key.upcase_first}"))
    }
  end

  def clean_item!(item)
    item['dettes3EmpruntsEtDettesAupresDesEtablissementsdeCredit'] = item.delete('dettes3EmruntsEtDettesAupresDesEtablissementsdeCredit')
  end

  def build_percent(value)
    return if value.blank?

    value.to_f.round(2)
  end

  def convert_to_euros(value)
    return 0 if value.blank?

    (value.to_i * 1000).to_s
  end
end
