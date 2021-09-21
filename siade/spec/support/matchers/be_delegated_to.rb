require 'rspec/expectations'

RSpec::Matchers.define :be_delegated_to do |expected, method_name|
  match do |_actual|
    allow_any_instance_of(expected).to receive(method_name).and_return('stubbed response')

    expect_any_instance_of(expected).to receive(method_name)

    subject.send(method_name) == 'stubbed response'
  end

  description do
    "delegate '#{method_name}' to #{expected}'"
  end

  failure_message do |actual|
    "expected that #{actual} would delegate #{method_name} to an instance of #{expected}"
  end
end
