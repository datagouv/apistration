require 'rspec/expectations'

RSpec::Matchers.define :has_existing_key_whose_value_eq do |key, value|
  match do |actual|
    actual.key?(key) && (actual[key] == value)
  end

  # :nocov:
  description do
    value = 'null' if value.nil?
    "has key #{key} whose value is #{value}"
  end

  failure_message do |actual|
    value = 'null' if value.nil?
    <<-EOS
    expected that
    #{actual}
    had key '#{key}' whose value would be '#{value}'
    EOS
  end
  # :nocov:
end
