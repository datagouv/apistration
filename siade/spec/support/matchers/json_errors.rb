require 'rspec/expectations'

RSpec::Matchers.define :have_error do |expected|
  match do |actual|
    actual.each do |object|
      expect(object).to be_a(ApplicationError)

    end

    expect(actual.map(&:detail)).to include(expected)
  end

  description do
    "includes #{expected.inspect} error message and is an ApplicationError instance"
  end

  failure_message do |actual|
    message = "expected that #{actual.inspect} to includes #{expected} message and to be an ApplicationError instance.\n\n"

    begin
      errors = actual.map(&:as_json)
      message +
        "Errors messages: #{errors.map(&:inspect).join(', ')}"
    rescue => e
      "#{actual.inspect} is not an array. (exception: #{e.inspect})"
    end
  end
end

RSpec::Matchers.define :have_json_error do |expected|
  match do |actual|
    json = actual.stringify_keys

    expect(json['errors']).to be_present
    expect(json['errors']).to be_an(Array)

    if ENV['JSON_API_FORMAT_ERROR'] == 'true'
      valid_json_error = json['errors'].find do |json_error|
        json_error.stringify_keys == expected.stringify_keys ||
          json_error.stringify_keys['detail'] == expected.stringify_keys['detail'] ||
          json_error.stringify_keys['code'] == expected.stringify_keys['code']
      end

      expect(valid_json_error).to be_present

      expect(valid_json_error.stringify_keys.keys).to include(*%w[title code detail])
      expect(valid_json_error.values).to include(*expected.values)
    else
      expect(json['errors']).to include(expected.stringify_keys['detail'])
    end
  end
end
