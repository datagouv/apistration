RSpec.describe BilansINPIPolicy do
  it_behaves_like 'jwt policy', :bilans_inpi, :bilans?

  # TODO: drop me rôle INPI in 2022/06
  it_behaves_like 'jwt policy', :actes_bilans_inpi, :bilans?
end
