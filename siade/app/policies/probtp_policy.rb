class PROBTPPolicy < APIPolicy
  def jwt_role_tag
    'probtp'
  end
end
