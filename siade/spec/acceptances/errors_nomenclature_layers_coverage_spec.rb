RSpec.describe 'Errors nomenclature layers coverage', type: :acceptance do
  let(:helper_bases) { [ValidateResponse, ValidateParamInteractor] }

  let(:renders_as) do
    {
      UnexpectedRedirectionError => ProviderInternalServerError
    }
  end

  let(:example_builders) do
    {
      UnexpectedRedirectionError => ->(provider_name) { UnexpectedRedirectionError.new(provider_name, nil) }
    }
  end

  let(:baseline_error_classes) do
    %i[entreprise particulier].flat_map { |api|
      baseline = Errors::BaselineErrors.new(api)

      baseline.platform + baseline.for_provider('INSEE')
    }.map(&:class).uniq
  end

  let(:error_classes_by_name) { ApplicationError.descendants.select(&:name).index_by(&:name) }

  before { Rails.application.eager_load! }

  def referenced_errors(klass)
    NomenclatureWalk.app_sources(klass, excluded: helper_bases)
      .flat_map { |path| File.read(path).scan(/\b[A-Z]\w*(?:::[A-Z]\w*)*\b/) }
      .uniq
      .filter_map { |name| error_classes_by_name[name] }
  end

  def documented?(error_class, documented_classes)
    documented_classes.include?(error_class) || documented_classes.include?(renders_as[error_class])
  end

  it 'documents every error a walked class or the layers it inherits can render' do
    undocumented = NomenclatureWalk.classes.each_with_object({}) do |klass, result|
      documented_classes = baseline_error_classes + (ErrorRegistry.declarations_for(klass) + ErrorRegistry.declarations_for_organizer(klass)).map(&:error_class)
      missing = referenced_errors(klass).reject { |error_class| documented?(error_class, documented_classes) }

      result[klass.name] = missing.map(&:name) if missing.any?
    end

    expect(undocumented).to be_empty, <<~MESSAGE
      These classes, or the layers they inherit such as RetrieverOrganizer or MakeRequest,
      render errors the nomenclature does not document. Declare them with `raises` on the
      class, or add them to Errors::BaselineErrors when every provider endpoint can render them:

      #{undocumented.map { |klass, errors| "#{klass}: #{errors.join(', ')}" }.join("\n")}
    MESSAGE
  end

  it 'lists as rendered like another error only a class rendering its code and status for every provider' do
    mismatches = renders_as.flat_map do |error_class, twin_class|
      ErrorsBackend.instance.providers.values.filter_map do |provider_name|
        error = example_builders.fetch(error_class).call(provider_name)
        twin = twin_class.build_example(provider_name:)

        "#{provider_name}: #{error.code} (#{error.kind}) vs #{twin.code} (#{twin.kind})" unless [error.code, error.kind] == [twin.code, twin.kind]
      end
    end

    expect(mismatches).to be_empty
  end
end
