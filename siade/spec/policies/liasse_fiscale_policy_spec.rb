RSpec.describe LiasseFiscalePolicy do
  it_behaves_like 'jwt policy', :liasse_fiscale
  it_behaves_like 'jwt policy', :liasse_fiscale, :declaration?
  it_behaves_like 'jwt policy', :liasse_fiscale, :dictionnaire?
end
