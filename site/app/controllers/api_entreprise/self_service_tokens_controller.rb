class APIEntreprise::SelfServiceTokensController < APIEntreprise::AuthenticatedUsersController
  include SelfServiceTokensManagement
end
