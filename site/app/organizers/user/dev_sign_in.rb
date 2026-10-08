class User::DevSignIn < ApplicationOrganizer
  organize User::Login::FindUserByEmail
end
