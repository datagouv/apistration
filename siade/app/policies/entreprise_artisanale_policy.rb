class EntrepriseArtisanalePolicy < APIPolicy
  def jwt_scope_tag
    'entreprises_artisanales'
  end
end
