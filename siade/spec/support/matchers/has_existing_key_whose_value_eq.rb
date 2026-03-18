require 'rspec/expectations'

RSpec::Matchers.define :has_existing_key_whose_value_eq do |key, value|
  match do |actual|
    actual.key?(key) && (actual[key] == value)
  end

  # :nocov:
  description do
    value = value.nil? ? 'null' : value
    "has key #{key} whose value is #{value.to_s}"
  end

  failure_message do |actual|
    value = value.nil? ? 'null' : value
    <<-EOS
    expected that
    #{actual}
    had key '#{key}' whose value would be '#{value.to_s}'
    EOS
  end
  # :nocov:
end
