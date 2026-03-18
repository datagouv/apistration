RSpec.describe EtablissementPolicy do
  it_behaves_like 'jwt policy', :etablissements

  it_behaves_like 'jwt policy', :etablissements, :show_with_non_diffusables?
end
