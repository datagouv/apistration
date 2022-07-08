class EORIDouanePolicy < APIPolicy
  def jwt_scope_tag
    'eori_douanes'
  end
end
