RSpec.describe 'Error codes unicity', type: :acceptance do
  let(:backend) { ErrorsBackend.instance }

  let(:data_providers) { backend.providers.except('00').values }

  before { Rails.application.eager_load! }

  def field_codes(error_class)
    Rails.root.join("app/errors/#{error_class.name.underscore}.rb").read
      .scan(/^\s+([a-z_]+): '(\d{5})',?$/)
      .to_h { |field, code| [code, "#{error_class}(#{field})"] }
  end

  def fixed_code_meanings
    ApplicationError.descendants.each_with_object({}) do |error_class, meanings|
      next unless carries_a_fixed_code?(error_class)

      code = fixed_code_of(error_class)
      next if code.nil?

      meanings[code] = error_class.name
    end
  end

  def carries_a_fixed_code?(error_class)
    return false if error_class.name.nil?
    return false if error_class <= AbstractGenericProviderError || error_class <= AbstractSpecificProviderError

    error_class == InvalidRecipientError || !(error_class <= UnprocessableEntityError)
  end

  def specific_provider_meanings
    AbstractSpecificProviderError.descendants.each_with_object({}) do |error_class, meanings|
      next if error_class.name.nil?

      subcode_config(error_class).each_key do |kind|
        meanings[error_class.new(kind).code] = "#{error_class}(#{kind})"
      end
    end
  end

  def generic_provider_meanings
    generic_subcodes.flat_map { |subcode, label|
      data_providers.map { |provider| [backend.provider_code_from_name(provider) + subcode, "#{label}(#{provider})"] }
    }.to_h
  end

  def generic_subcodes
    subcodes = AbstractGenericProviderError.descendants.filter_map { |error_class|
      next if error_class.name.nil? || error_class == BadFileFromProviderError

      subcode = subcode_of(error_class)
      [subcode, error_class.name] if subcode
    }.to_h

    BadFileFromProviderError::KIND_TO_SUBCODE.each do |kind, attributes|
      subcodes[attributes[:subcode]] = "BadFileFromProviderError(#{kind})"
    end

    subcodes
  end

  def subcode_config(error_class)
    error_class.allocate.send(:subcode_config)
  rescue StandardError
    {}
  end

  def fixed_code_of(error_class)
    error_class.new.code
  rescue ArgumentError
    begin
      error_class.new('api_entreprise').code
    rescue StandardError
      nil
    end
  rescue StandardError
    nil
  end

  def subcode_of(error_class)
    error_class.new('INSEE').subcode
  rescue ArgumentError
    begin
      error_class.new('INSEE', 'reason').subcode
    rescue StandardError
      nil
    end
  rescue StandardError
    nil
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
