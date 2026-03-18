class AssociationPolicy < APIPolicy
  def jwt_role_tag
    'associations'
  end
end
