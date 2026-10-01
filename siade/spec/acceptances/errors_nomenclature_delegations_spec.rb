RSpec.describe 'Errors nomenclature delegations', type: :acceptance do
  before { Rails.application.eager_load! }

  def erroring_classes
    @erroring_classes ||= (ApplicationInteractor.descendants + ApplicationOrganizer.descendants)
      .select(&:name)
      .uniq
      .select { |klass| renders_errors?(klass) }
  end

  def renders_errors?(klass)
    klass < RetrieverOrganizer ||
      ErrorRegistry.delegations_for(klass).any? ||
      ErrorRegistry.declarations_for_organizer(klass).any?
  end

  def referenced_classes(klass)
    source = File.read(NomenclatureWalk.source_path(klass))

    erroring_classes.select { |candidate| candidate != klass && source.match?(/(?<![\w:])#{Regexp.escape(candidate.name)}(?![\w:])/) }
  end

  def accounted_for(klass)
    klass.ancestors +
      ErrorRegistry.chain_of(klass) +
      Array(klass.try(:organized)) +
      ErrorRegistry.delegations_for(klass) +
      ErrorRegistry.absorptions_for(klass)
  end

  it 'declares every class with errors a walked class runs outside its organize chain' do
    undeclared = NomenclatureWalk.classes.each_with_object({}) do |klass, result|
      missing = referenced_classes(klass) - accounted_for(klass)

      result[klass.name] = missing.map(&:name) if missing.any?
    end

    expect(undeclared).to be_empty, <<~MESSAGE
      These classes run another interactor or retriever outside their organize chain, so
      the errors it renders reach the caller without the nomenclature knowing them.
      Declare it with `delegates_to` when its errors are relayed (a retriever's under its
      own provider, anything else as the caller's), or `absorbs_errors_of` when the caller
      turns its failure into an error of its own:

      #{undeclared.map { |klass, classes| "#{klass}: #{classes.join(', ')}" }.join("\n")}
    MESSAGE
  end
end
