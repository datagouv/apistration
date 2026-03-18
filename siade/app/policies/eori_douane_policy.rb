class EORIDouanePolicy < APIPolicy
  def jwt_role_tag
    'eori_douanes'
  end
end
