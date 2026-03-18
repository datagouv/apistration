class ConventionsCollectivePolicy < APIPolicy
  def jwt_role_tag
    'conventions_collectives'
  end
end
