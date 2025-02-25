class DGFIP::LiensCapitalistiques::BuildResourceFromLiassesFiscales < ApplicationInteractor
  def call
    context.bundled_data = BundledData.new(
      data: Resource.new(
        capital: build_capital,
        participations: build_participations
      ),
      context: context.bundled_data.context
    )
  end

  private

  def build_capital
    {
      actionnaires: build_actionnaires,
      repartition: {
        personnes_physiques: {
          total_actions: build_entier(values('2059F', '309326')[0]),
          nombre: build_entier(values('2059F', '309325')[0])
        },
        personnes_morales: {
          total_actions: build_entier(values('2059F', '309324')[0]),
          nombre: build_entier(values('2059F', '309323')[0])
        }
      },
      depose_neant: neant?('2059F')
    }
  end

  def build_participations
    {
      filiales: build_filiales,
      nombre_filiales: build_entier(values('2059G', '309327')[0]),
      depose_neant: neant?('2059G')
    }
  end

  def build_actionnaires
    return [] if declaration('2059F').nil?

    actionnaires = []

    sirens = values('2059F', '304859')

    sirens.count.times do |index|
      actionnaires << build_personne_morale_actionnaire(index)
    end

    noms_personnes_physiques = values('2059F', '304868')

    noms_personnes_physiques.count.times do |index|
      actionnaires << build_personne_physique_actionnaire(index)
    end

    actionnaires
  end

  def build_filiales
    return [] if declaration('2059G').nil?

    values('2059G', '304960').map.with_index do |_, index|
      build_filiale(index)
    end
  end

  def build_filiale(index)
    {
      siren: values('2059G', '304960')[index],
      denomination: values('2059G', '304958')[index],
      complement_denomination: values('2059G', '304959')[index],
      forme_juridique: values('2059G', '306876')[index],
      pourcentage_detention: build_pourcentage(values('2059G', '304967')[index]),
      adresse: build_filiale_adresse(index)
    }
  end

  def build_filiale_adresse(index)
    {
      numero: values('2059G', '304961')[index],
      voie: values('2059G', '304962')[index],
      lieu_dit_hameau: values('2059G', '304963')[index],
      code_postal: values('2059G', '304964')[index],
      ville: values('2059G', '304965')[index],
      pays: values('2059G', '304966')[index]
    }
  end

  def build_personne_morale_actionnaire(index)
    {
      type: 'personne_morale',
      pourcentage: build_pourcentage(values('2059F', '304861')[index]),
      nombre_parts: build_entier(values('2059F', '304860')[index]),
      attributs: {
        siren: values('2059F', '304859')[index],
        denomination: values('2059F', '304857')[index],
        complement_denomination: values('2059F', '304858')[index],
        forme_juridique: values('2059F', '306875')[index]
      },
      adresse: build_personne_morale_adresse_actionnaire(index)
    }
  end

  def build_personne_morale_adresse_actionnaire(index)
    {
      numero: values('2059F', '304862')[index],
      voie: values('2059F', '304863')[index],
      lieu_dit_hameau: values('2059F', '304864')[index],
      code_postal: values('2059F', '304865')[index],
      ville: values('2059F', '304866')[index],
      pays: values('2059F', '304867')[index]
    }
  end

  def build_personne_physique_actionnaire(index)
    {
      type: 'personne_physique',
      pourcentage: build_pourcentage(values('2059F', '304871')[index]),
      nombre_parts: build_entier(values('2059F', '304870')[index]),
      attributs: build_personne_physique_attributs_actionnaire(index),
      adresse: build_personne_physique_adresse_actionnaire(index)
    }
  end

  def build_personne_physique_attributs_actionnaire(index)
    {
      civilite: values('2059F', '306874')[index],
      nom_patronymique_et_prenoms: values('2059F', '304868')[index],
      nom_marital: values('2059F', '304869')[index],
      date_naissance: build_date_naissance(values('2059F', '304878')[index]),
      ville_naissance: values('2059F', '905900')[index],
      departement_naissance: values('2059F', '905901')[index],
      pays_naissance: values('2059F', '905902')[index]
    }
  end

  def build_personne_physique_adresse_actionnaire(index)
    {
      numero: values('2059F', '304872')[index],
      voie: values('2059F', '304873')[index],
      lieu_dit_hameau: values('2059F', '304874')[index],
      code_postal: values('2059F', '304875')[index],
      ville: values('2059F', '304876')[index],
      pays: values('2059F', '304877')[index]
    }
  end

  def build_date_naissance(date)
    if date.blank?
      {
        annee: nil,
        mois: nil,
        jour: nil
      }
    else
      {
        annee: date[0..3],
        mois: date[4..5],
        jour: date[6..7]
      }
    end
  end

  def build_pourcentage(value)
    return nil if value.nil?

    value.to_f / 100
  end

  def build_entier(value)
    return nil if value.nil?

    value.to_i / 100
  end

  def neant?(imprime)
    values(imprime, neant_code_nref(imprime)).any?
  end

  def neant_code_nref(imprime)
    case imprime
    when '2059F'
      '305767'
    when '2059G'
      '305768'
    end
  end

  def values(imprime, code_nref)
    @values ||= {}
    @values["#{imprime}_#{code_nref}"] ||= find_nref_within_declaration(imprime, code_nref)
    @values["#{imprime}_#{code_nref}"] || []
  end

  def find_nref_within_declaration(imprime, code_nref)
    (declaration(imprime)[:donnees] || []).find { |entry| entry[:code_nref] == code_nref }&.dig(:valeurs) || []
  end

  def declaration(imprime)
    @declarations ||= {}
    @declarations[imprime] ||= all_declarations.find { |declaration| declaration[:numero_imprime] == imprime }
    @declarations[imprime] || {}
  end

  def all_declarations
    context.bundled_data.data.declarations
  end
end
