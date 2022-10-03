class DGFIP::LiassesFiscales::EnrichResource < ApplicationInteractor
  def call
    declarations = context.bundled_data.data.declarations

    enrich!(declarations)
  end

  private

  def enrich!(declarations)
    declarations.map do |declaration|
      enrich_declaration_with_code_nref!(declaration)
    end
  end

  def enrich_declaration_with_code_nref!(declaration)
    declaration[:donnees] = donnees_with_enriched_code_nref(declaration)
  end

  def donnees_with_enriched_code_nref(declaration)
    declaration[:donnees].map do |donnee|
      donnee_with_enriched_code_nref(donnee, declaration)
    end
  end

  def donnee_with_enriched_code_nref(donnee, declaration)
    enrich_code_nref(donnee, declaration)
  end

  def enrich_code_nref(donnee, declaration)
    enrichment = enrichment_for_code_nref_from_dictionary_data(donnee, declaration[:numero_imprime])

    return donnee unless enrichment

    donnee.merge(enrichment.except(:code_nref))
  end

  def enrichment_for_code_nref_from_dictionary_data(donnee, numero_imprime)
    dictionary_data_for_imprime(numero_imprime)&.find do |data_declaration|
      data_declaration[:code_nref] == donnee[:code_nref]
    end
  end

  def dictionary_data_for_imprime(numero_imprime)
    dictionary_lookup(numero_imprime).map { |entry| entry.transform_keys(&:to_sym) }
  end

  def dictionary_lookup(numero_imprime)
    DGFIP::Dictionaries.call(key: redis_key(numero_imprime))
  end

  def redis_key(numero_imprime)
    "dgfip:dictionnaires:year_#{year}:imprime_#{numero_imprime}"
  end

  def year
    context.params[:year]
  end
end
