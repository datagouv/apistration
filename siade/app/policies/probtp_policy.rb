class PROBTPPolicy < APIPolicy
  def jwt_scope_tag
    'probtp'
  end
end
