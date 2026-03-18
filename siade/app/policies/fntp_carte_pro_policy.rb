class FNTPCarteProPolicy < APIPolicy
  def jwt_role_tag
    'fntp_carte_pro'
  end
end
