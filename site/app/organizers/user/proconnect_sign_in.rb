class User::ProconnectSignIn < ApplicationOrganizer
  organize User::Login::ValidateOAuthProvider,
    User::Login::ValidateOmniauthData,
    User::Login::EnsureMfa,
    User::Login::ExtractProconnectUserParams,
    User::ProconnectLogin
end
