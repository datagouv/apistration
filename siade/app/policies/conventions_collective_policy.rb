class ConventionsCollectivePolicy < APIPolicy
  def jwt_scope_tag
    'conventions_collectives'
  end
end
