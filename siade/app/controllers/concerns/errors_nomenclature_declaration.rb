module ErrorsNomenclatureDeclaration
  extend ActiveSupport::Concern

  Declaration = Data.define(:organizers) do
    def versions
      organizers.keys.sort
    end

    def organizer_for(version)
      organizers[version]
    end
  end

  included do
    class_attribute :errors_nomenclature_declaration, instance_accessor: false
  end

  class_methods do
    def nomenclature(organizers:)
      self.errors_nomenclature_declaration = Declaration.new(organizers: organizers.freeze)
    end
  end
end
