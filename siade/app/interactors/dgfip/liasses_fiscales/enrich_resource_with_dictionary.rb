class DGFIP::LiassesFiscales::EnrichResourceWithDictionary < ApplicationInteractor
  def self.dictionary_key(declaration, default_key)
    declaration[:millesime].to_s[0, 4].presence || default_key
  end

  def call
    declarations.map do |declaration|
      enrich_declaration_with_code_nref!(declaration)
    end
  end

  protected

  def declarations
    context.declarations || context.bundled_data.data.declarations
  end

  def dictionary_for(declaration)
    context.dictionaries.fetch(self.class.dictionary_key(declaration, context.default_dictionary_key))
  end

  private

  def enrich_declaration_with_code_nref!(declaration)
    declaration[:donnees] = donnees_with_enriched_code_nref(declaration)
  end

  def donnees_with_enriched_code_nref(declaration)
    declaration[:donnees].map { |donnee|
      donnee_with_enriched_code_nref(donnee, declaration)
    }.uniq
  end

  def donnee_with_enriched_code_nref(donnee, declaration)
    enrich_code_nref(donnee, declaration)
  end

  def enrich_code_nref(donnee, declaration)
    enrichment = enrichment_for_code_nref_from_dictionary_data(donnee, declaration)

    return donnee unless enrichment

    donnee.merge(enrichment.except(:code_nref))
  end

  def enrichment_for_code_nref_from_dictionary_data(donnee, declaration)
    formatted_declaration_dictionary_data_for_imprime(dictionary_for(declaration), declaration[:numero_imprime])&.find do |data|
      data[:code_nref] == donnee[:code_nref]
    end
  end

  def formatted_declaration_dictionary_data_for_imprime(dictionary, numero_imprime)
    declaration_dictionary_data_for_imprime(dictionary, numero_imprime)&.map { |entry| entry.transform_keys(&:to_sym) }
  end

  def declaration_dictionary_data_for_imprime(dictionary, numero_imprime)
    dictionary_data_for_imprime(dictionary, numero_imprime).try(:[], 'millesimes').try(:[], 'declaration')
  end

  def dictionary_data_for_imprime(dictionary, numero_imprime)
    dictionary.find { |entry| entry['numero_imprime'] == numero_imprime }
  end
end
