RSpec.describe 'Errors nomenclature platform coverage', type: :acceptance do
  let(:undocumentable) do
    {
      NotImplementedYetError => 'its kind :internal_error has no HTTP status in Errors::HTTPStatusForKind, ' \
                                'and the controller renders it as 501 regardless'
    }
  end

  let(:base_controllers) do
    [APIEntreprise::V3AndMore::BaseController, APIParticulier::V3AndMore::BaseController]
  end

  let(:rack_layer_sources) do
    [Rails.root.join('config/initializers/rack_attack.rb').to_s]
  end

  let(:shared_layer_sources) do
    base_controllers
      .flat_map { |controller_class| controller_class.ancestors.filter_map { |mod| source_path(mod) } }
      .uniq
      .select { |path| path.start_with?(Rails.root.join('app/controllers').to_s) } + rack_layer_sources
  end

  let(:shared_layer_errors) do
    shared_layer_sources
      .flat_map { |path| File.read(path).scan(/\b([A-Z][A-Za-z]*Error)\b/).flatten }
      .uniq
      .filter_map(&:safe_constantize)
      .select { |constant| ApplicationError.descendants.include?(constant) }
  end

  let(:routed_v3_controllers) do
    Rails.application.routes.routes.filter_map { |route|
      controller = route.defaults[:controller]
      next unless controller&.include?('v3_and_more')

      "#{controller}_controller".camelize.constantize
    }.uniq
  end

  let(:error_classes_by_name) { ApplicationError.descendants.select(&:name).index_by(&:name) }

  def controller_errors(controller_class)
    controller_class.ancestors
      .filter_map { |mod| source_path(mod) }
      .uniq
      .select { |path| path.start_with?(Rails.root.join('app/controllers').to_s) }
      .flat_map { |path| File.read(path).scan(/\b[A-Z]\w*(?:::[A-Z]\w*)*\b/) }
      .uniq
      .filter_map { |name| error_classes_by_name[name] }
  end

  def api_of(controller_class)
    controller_class.name.start_with?('APIEntreprise') ? :entreprise : :particulier
  end

  def operation_error_classes(controller_class)
    nomenclature = ErrorsNomenclature.new(api_of(controller_class))

    controller_class.errors_nomenclature_declaration.organizers.values.flat_map { |organizer|
      nomenclature.send(:endpoint_errors, controller_class, organizer, organizer.provider_name)
    }.map(&:class)
  end

  def source_path(mod)
    Object.const_source_location(mod.name)&.first if mod.name
  end

  def platform_error_classes(api)
    Errors::BaselineErrors.new(api).platform.map(&:class)
  end

  before { Rails.application.eager_load! }

  it 'scans the layers every endpoint crosses before its organizer' do
    expect(shared_layer_errors).to include(InvalidRecipientError, UnsupportedAPIVersionError, DelegationSiretMismatchError)
    expect(shared_layer_errors).to include(ForbiddenIpError)
  end

  %i[entreprise particulier].each do |api|
    it "documents on api_#{api} every error that layer renders on its own" do
      undocumented = shared_layer_errors - platform_error_classes(api) - undocumentable.keys

      expect(undocumented).to be_empty, <<~MESSAGE
        These errors are rendered by the Rack blocklist responder, or by a before_action
        or a rescue_from shared by every endpoint, so no organizer declares them and the
        nomenclature cannot infer them. Add them to Errors::BaselineErrors#platform:

        #{undocumented.inspect}
      MESSAGE
    end
  end

  it 'documents every error a routed v3+ controller renders, whatever it inherits from' do
    undocumented = routed_v3_controllers.each_with_object({}) do |controller_class, result|
      documented = platform_error_classes(api_of(controller_class)) + operation_error_classes(controller_class) + undocumentable.keys
      missing = controller_errors(controller_class) - documented

      result[controller_class.name] = missing.map(&:name) if missing.any?
    end

    expect(undocumented).to be_empty, <<~MESSAGE
      These controllers render errors that are neither platform codes nor errors of their
      operations. A controller the nomenclature leaves out, like the token introspection,
      may only render platform codes: add the error to Errors::BaselineErrors#platform, or
      declare it on the organizer of the operation.

      #{undocumented.map { |controller, errors| "#{controller}: #{errors.join(', ')}" }.join("\n")}
    MESSAGE
  end
end
