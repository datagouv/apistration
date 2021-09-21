# rubocop:disable Style/MutableConstant
RSPEC_GLOBAL = {}

def remember_through_each_test_of_current_scope(variable_name)
  instance_variable_set("@#{variable_name}", RSPEC_GLOBAL[variable_name] || begin
    yield
  end)
  RSPEC_GLOBAL[variable_name] ||= instance_variable_get("@#{variable_name}")
end
# rubocop:enable Style/MutableConstant
