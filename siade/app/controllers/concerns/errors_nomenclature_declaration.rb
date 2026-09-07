module ErrorsNomenclatureDeclaration
  extend ActiveSupport::Concern

  Declaration = Data.define(:organizers) do
    def documented?
      organizers.any?
    end

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

    def nomenclature_undocumented!
      self.errors_nomenclature_declaration = Declaration.new(organizers: {}.freeze)
    end
  end
end
