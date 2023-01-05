class APIEntreprise::MI::UniteLegaleSerializer::V4 < APIEntreprise::MI::UniteLegaleSerializer::SharedV4
  attributes :reseaux_affiliation

  attribute :etablissements do |object|
    object.etablissements.map do |etablissement|
      etablissement[:documents_dac] = etablissement[:documents_dac].map do |document|
        document.except(:id).merge(
          url: url_for_proxied_file(document[:url])
        )
      end

      etablissement
    end
  end

  attribute :documents_rna do |object|
    object.documents_rna.map do |document|
      document.except(:id).merge(
        url: url_for_proxied_file(document[:url])
      )
    end
  end
end
