RSpec.describe ActesINPIPolicy do
  it_behaves_like 'jwt policy', :actes_inpi, :actes?

  # TODO: drop me rôle INPI in 2022/06
  it_behaves_like 'jwt policy', :actes_bilans_inpi, :actes?
end
