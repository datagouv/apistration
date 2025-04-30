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
    rescue StandardError => e
      "#{actual.inspect} is not an array. (exception: #{e.inspect})"
    end
  end
end

RSpec::Matchers.define :have_json_error do |expected|
  match do |actual|
    expect(actual).to have_json_api_format_errors

    json = actual.stringify_keys

    expect(json['errors'].map { |error| error.stringify_keys['detail'] }).to include(expected.stringify_keys['detail'])
  end
end

RSpec::Matchers.define :have_json_api_format_errors do
  match do |actual|
    json = actual.stringify_keys

    expect(json['errors']).to be_present
    expect(json['errors']).to be_an(Array)
    expect(json['errors'].first.stringify_keys.keys).to include('detail', 'code', 'title')
  end
end

RSpec::Matchers.define :have_flat_format_error do
  match do |actual|
    json = actual.stringify_keys

    expect(json['errors'].first).to be_present
    expect(json['errors'].first).to be_a(String)
  end
end
