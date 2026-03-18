class EntrepriseArtisanalePolicy < APIPolicy
  def jwt_role_tag
    'entreprises_artisanales'
  end
end
