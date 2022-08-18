class APIParticulier::DGFIP::SVAIR::V2 < APIParticulier::V2BaseSerializer
  %i[
    date_recouvrement
    date_etablissement
    nombre_parts
    revenu_brut_global
    revenu_imposable
    impot_revenu_net_avant_corrections
    montant_impot
    revenu_fiscal_reference
    annee_revenus
    erreur_correctif
    situation_partielle
  ].each do |resource_attribute|
    attribute resource_attribute.to_s.camelize(:lower), if: -> { scope?("dgfip_#{resource_attribute}".to_sym) }
  end

  # rubocop:disable Naming/VariableNumber
  attributes :declarant1, :declarant2
  attribute :foyerFiscal, method: :foyer_fiscal

  attribute :situationFamille, if: -> { scope?(:dgfip_situation_familiale) }
  attribute :nombrePersonnesCharge, if: -> { scope?(:dgfip_nombre_personnes_a_charge) }
  attribute :anneeImpots, if: -> { scope?(:dgfip_annee_impot) }

  def declarant1
    build_declarant(1)
  end

  def declarant2
    build_declarant(2)
  end
  # rubocop:enable Naming/VariableNumber

  def foyer_fiscal
    {
      adresse: attribute_or_nil_if_scope(object.foyerFiscal[:adresse], scope: 'dgfip_adresse_fiscale_taxation'),
      annee: attribute_or_nil_if_scope(object.foyerFiscal[:annee], scope: 'dgfip_adresse_fiscale_annee')
    }.compact
  end

  private

  def build_declarant(position)
    declarant_data = object.public_send("declarant#{position}")

    {
      nom: attribute_or_nil_if_scope(declarant_data[:nom], scope: "dgfip_declarant#{position}_nom"),
      nomNaissance: attribute_or_nil_if_scope(declarant_data[:nomNaissance], scope: "dgfip_declarant#{position}_nom_naissance"),
      prenoms: attribute_or_nil_if_scope(declarant_data[:prenoms], scope: "dgfip_declarant#{position}_prenoms"),
      dateNaissance: attribute_or_nil_if_scope(declarant_data[:dateNaissance], scope: "dgfip_declarant#{position}_date_naissance")
    }.compact
  end

  def attribute_or_nil_if_scope(value, scope:)
    return unless scope?(scope)

    value
  end
end
