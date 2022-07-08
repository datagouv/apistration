class AssociationPolicy < APIPolicy
  def jwt_scope_tag
    'associations'
  end
end
