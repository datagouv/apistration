module NomenclatureWalk
  module_function

  def classes
    pending = documented_organizers
    walked = Set.new

    until pending.empty?
      klass = pending.shift
      next unless walked.add?(klass)

      pending.concat(Array(klass.try(:organized)), ErrorRegistry.delegations_for(klass))
    end

    walked.select(&:name)
  end

  def documented_organizers
    %i[entreprise particulier].flat_map { |api|
      ErrorsNomenclature.new(api).send(:documented_controller_classes).flat_map do |controller_class|
        controller_class.errors_nomenclature_declaration.organizers.values
      end
    }.uniq + [FranceConnect::DataFetcherThroughAccessToken]
  end

  def source_path(klass)
    Object.const_source_location(klass.name)&.first if klass.name
  end

  def app_sources(klass, excluded: [])
    (klass.ancestors - excluded).filter_map { |mod| source_path(mod) }.uniq.select { |path| path.start_with?(Rails.root.join('app').to_s) }
  end
end
