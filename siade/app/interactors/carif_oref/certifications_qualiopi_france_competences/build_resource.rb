class CarifOref::CertificationsQualiopiFranceCompetences::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      siret: json_body['siret_actif'],
      code_uai: etablissement['uai'],
      unite_legale_avec_plusieurs_nda: string_to_bool(unite_legale['multinda']),
      declarations_activites_etablissement:,
      habilitations_france_competence:
    }
  end

  private

  # rubocop:disable Metrics/AbcSize
  def declarations_activites_etablissement
    json_body['nda'].map do |nda_payload|
      {
        numero_de_declaration: nda_payload['nda'],
        actif: string_to_bool(nda_payload['actif']),
        date_derniere_declaration: nda_payload['date_derniere_declaration'],
        date_fin_exercice: nda_payload['fin_exercice'],
        certification_qualiopi: {
          action_formation: string_to_bool(nda_payload['qualiopi_action_formation']),
          bilan_competences: string_to_bool(nda_payload['qualiopi_bilan_comptence']),
          validation_acquis_experience: string_to_bool(nda_payload['qualiopi_vae']),
          apprentissage: string_to_bool(nda_payload['qualiopi_apprentissage']),
          obtention_via_unite_legale: obtention_via_unite_legale(nda_payload['obtention_qualiopi'])
        },
        specialites: {
          specialite_1: build_speciality(nda_payload, 1),
          specialite_2: build_speciality(nda_payload, 2),
          specialite_3: build_speciality(nda_payload, 3)
        }
      }
    end
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def habilitations_france_competence
    valid_habilitations.map do |habilitation_payload|
      {
        code: habilitation_payload['code_fc'],
        actif: string_to_bool(habilitation_payload['actif']),
        date_actif: format_date(habilitation_payload['date_habilitation']),
        date_fin_enregistrement: format_date(habilitation_payload['date_fin_enregistrement']),
        date_decision: format_date(habilitation_payload['date_decision']),
        habilitation_pour_former: string_to_bool(habilitation_payload['a_former']),
        habilitation_pour_organiser_l_evaluation: string_to_bool(habilitation_payload['a_organiser']),
        sirets_organismes_certificateurs: habilitation_payload['certificateur'].pluck('siret')
      }
    end
  end
  # rubocop:enable Metrics/AbcSize

  def valid_habilitations
    json_body['habilitations'].reject do |habilitation_payload|
      habilitation_payload['etat_habilitation'] == 'Supprimé'
    end
  end

  def obtention_via_unite_legale(value)
    return if value.blank?

    if value.include?('direct sur le NDA')
      false
    elsif value.include?('par propagation via')
      true
    end
  end

  def build_speciality(nda_payload, index)
    {
      code: nda_payload["code_specialite_#{index}"],
      libelle: nda_payload["libelle_specialite_#{index}"]
    }
  end

  def etablissement
    json_body['etablissement']
  end

  def unite_legale
    json_body['unite_legale']
  end

  def string_to_bool(string)
    case string
    when 'True', 'true' then true
    when 'False', 'false' then false
    end
  end

  def format_date(date)
    return unless date

    Date.parse(date).strftime('%Y-%m-%d')
  end
end
