require 'rspec/expectations'

def try_upcase(value)
  if value.kind_of?(String)
    value.upcase
  else
    value
  end
end

RSpec::Matchers.define :has_existing_key_whose_upcased_value_eq do |key, value|
  match do |actual|
    almost_identic = ( try_upcase(actual[key]) == try_upcase(value) )
    actual.key?(key) && almost_identic
  end

  description do
    value = value.nil? ? 'null' : value
    "has key '#{key}' whose upcased value is '#{try_upcase(value).to_s}'"
  end

  failure_message do |actual|
    value = value.nil? ? 'null' : value
    <<-EOS
    expected that
    #{actual}
    had key '#{key}' whose upcased value would be '#{try_upcase(value).to_s}'
    EOS
  end
end
