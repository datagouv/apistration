RSpec.describe EntreprisePolicy do
  it_behaves_like 'jwt policy', :entreprises

  it_behaves_like 'jwt policy', :entreprises, :show_with_non_diffusables?
end
