RSpec.describe 'Error codes unicity', type: :acceptance do
  let(:backend) { ErrorsBackend.instance }

  let(:data_providers) { backend.providers.except('00').values }

  before { Rails.application.eager_load! }

  def field_codes(error_class)
    Rails.root.join("app/errors/#{error_class.name.underscore}.rb").read
      .scan(/^\s+([a-z_]+): '(\d{5})',?$/)
      .map { |field, code| [code, "#{error_class}(#{field})"] }
  end

  def abstract_error_classes
    [UnauthorizedError, ForbiddenError, AbstractGenericProviderError, AbstractSpecificProviderError]
  end

  def application_descendants(error_class)
    error_class.descendants.select { |descendant| defined_in_app?(descendant) } - abstract_error_classes
  end

  def defined_in_app?(error_class)
    return false if error_class.name.nil?

    Object.const_source_location(error_class.name).first.to_s.start_with?(Rails.root.join('app').to_s)
  end

  def fixed_code_meanings
    application_descendants(ApplicationError).filter_map do |error_class|
      next unless carries_a_fixed_code?(error_class)

      [fixed_code_of(error_class), fixed_code_label(error_class)]
    end
  end

  def carries_a_fixed_code?(error_class)
    return true if bound_to_a_provider?(error_class)
    return false if error_class <= AbstractGenericProviderError || error_class <= AbstractSpecificProviderError
    return false if error_class == BadFileFromProviderError

    error_class == InvalidRecipientError || !(error_class <= UnprocessableEntityError)
  end

  def bound_to_a_provider?(error_class)
    error_class < AbstractGenericProviderError && error_class.instance_method(:initialize).arity.zero?
  end

  def fixed_code_label(error_class)
    return error_class.name if bound_to_a_provider?(error_class)

    error_class.instance_method(:code).owner.name
  end

  def specific_provider_meanings
    application_descendants(AbstractSpecificProviderError).flat_map do |error_class|
      subcode_config(error_class).keys.map { |kind| [error_class.new(kind).code, "#{error_class}(#{kind})"] }
    end
  end

  def generic_provider_meanings
    generic_subcodes.flat_map do |subcode, label|
      data_providers.map { |provider| [backend.provider_code_from_name(provider) + subcode, "#{label}(#{provider})"] }
    end
  end

  def generic_subcodes
    subcodes = application_descendants(AbstractGenericProviderError).reject { |error_class| bound_to_a_provider?(error_class) }.flat_map do |error_class|
      next variant_subcodes(ProviderUnprocessableEntityError::SUBCODES, error_class) if error_class == ProviderUnprocessableEntityError

      [[subcode_of(error_class), error_class.instance_method(:subcode).owner.name]]
    end

    subcodes + variant_subcodes(BadFileFromProviderError::KIND_TO_SUBCODE.transform_values { |attributes| attributes[:subcode] }, BadFileFromProviderError)
  end

  def variant_subcodes(subcode_by_variant, error_class)
    subcode_by_variant.map { |variant, subcode| [subcode, "#{error_class}(#{variant})"] }
  end

  def subcode_config(error_class)
    error_class.allocate.send(:subcode_config)
  end

  def subcode_of(error_class)
    error_class.new('INSEE').subcode
  rescue ArgumentError
    error_class.new('INSEE', nil).subcode
  end

  def fixed_code_of(error_class)
    error_class.new.code
  rescue ArgumentError
    error_class.new('api_entreprise').code
  end

  it 'never gives the same code two meanings' do
    meanings = Hash.new { |hash, key| hash[key] = [] }

    [field_codes(UnprocessableEntityError),
     field_codes(MissingMandatoryParamError),
     fixed_code_meanings,
     specific_provider_meanings,
     generic_provider_meanings].each do |source|
      source.each { |code, label| meanings[code] << label }
    end

    ambiguous = meanings.select { |_, labels| labels.uniq.size > 1 }

    expect(ambiguous).to be_empty,
      "codes with more than one meaning:\n#{ambiguous.map { |code, labels| "  #{code}: #{labels.uniq.join(' | ')}" }.join("\n")}"
  end
end
