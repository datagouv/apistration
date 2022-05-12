class Infogreffe::MandatairesSociaux::BuildResourceCollection < BuildResourceCollection
  include Infogreffe::Concerns::MandatairesSociaux

  def initialize(params)
    super(params)

    @personnes_physiques_count = @personnes_morales_count = 0
  end

  protected

  def items
    infos = Nokogiri.XML(body)

    extract_mandataires_sociaux(infos)
  end

  def items_meta
    {
      personnes_physiques_count: @personnes_physiques_count,
      personnes_morales_count: @personnes_morales_count,
      count: @personnes_morales_count + @personnes_physiques_count
    }
  end

  def resource_attributes(dirigeant)
    if personne_physique?(dirigeant)
      @personnes_physiques_count += 1
      mandataire_personne_physique(dirigeant)
    else
      @personnes_morales_count += 1
      mandataire_personne_morale(dirigeant)
    end
  end

  private

  def mandataire_personne_physique(dirigeant)
    {
      type: 'personne_physique',
      nom: nom(dirigeant),
      prenom: prenom(dirigeant),
      fonction: fonction(dirigeant),
      date_naissance: date_naissance(dirigeant),
      date_naissance_timestamp: date_naissance_timestamp(dirigeant),
      lieu_naissance: lieu_naissance(dirigeant),
      pays_naissance: pays_naissance(dirigeant),
      code_pays_naissance: code_pays_naissance(dirigeant),
      nationalite: nationalite(dirigeant),
      code_nationalite: code_nationalite(dirigeant)
    }
  end

  def mandataire_personne_morale(dirigeant)
    {
      type: 'personne_morale',
      numero_identification: identifiant(dirigeant),
      fonction: fonction(dirigeant),
      raison_sociale: raison_sociale(dirigeant),
      code_greffe: code_greffe(dirigeant),
      libelle_greffe: libelle_greffe(dirigeant)
    }
  end
end
