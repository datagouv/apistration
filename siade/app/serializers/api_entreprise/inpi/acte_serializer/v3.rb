class APIEntreprise::INPI::ActeSerializer::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  class ItemSerializer < APIEntreprise::V3AndMore::BaseSerializer
    link :greffe, &:greffe_url

    attribute :type do
      'acte'
    end

    attributes :siren,
      :code_greffe,
      :date_depot,
      :nature_archive
  end

  item_serializer ItemSerializer
end
