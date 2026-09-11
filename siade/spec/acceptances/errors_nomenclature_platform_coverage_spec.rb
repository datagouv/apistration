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

  let(:shared_layer_sources) do
    base_controllers
      .flat_map { |controller_class| controller_class.ancestors.filter_map { |mod| source_path(mod) } }
      .uniq
      .select { |path| path.start_with?(Rails.root.join('app/controllers').to_s) }
  end

  let(:shared_layer_errors) do
    shared_layer_sources
      .flat_map { |path| File.read(path).scan(/\b([A-Z][A-Za-z]*Error)\b/).flatten }
      .uniq
      .filter_map(&:safe_constantize)
      .select { |error_class| error_class.is_a?(Class) && error_class < ApplicationError }
  end

  def source_path(mod)
    Object.const_source_location(mod.name)&.first if mod.name
  end

  def platform_error_classes(api)
    Errors::BaselineErrors.new(api).platform.map(&:class)
  end

  before { Rails.application.eager_load! }

  it 'scans the layer every endpoint runs before its organizer' do
    expect(shared_layer_errors).to include(InvalidRecipientError, UnsupportedAPIVersionError, DelegationSiretMismatchError)
  end

  %i[entreprise particulier].each do |api|
    it "documents on api_#{api} every error that layer renders on its own" do
      undocumented = shared_layer_errors - platform_error_classes(api) - undocumentable.keys

      expect(undocumented).to be_empty, <<~MESSAGE
        These errors are rendered by a before_action or a rescue_from shared by every
        endpoint, so no organizer declares them and the nomenclature cannot infer them.
        Add them to Errors::BaselineErrors#platform:

        #{undocumented.inspect}
      MESSAGE
    end
  end
end
