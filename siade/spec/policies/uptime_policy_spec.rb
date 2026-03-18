RSpec.describe UptimePolicy do
  it_behaves_like 'jwt policy', :uptime, :robot?
end
