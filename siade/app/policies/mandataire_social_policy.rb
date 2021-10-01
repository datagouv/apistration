class MandataireSocialPolicy < APIPolicy
  def jwt_role_tag
    'mandataires_sociaux'
  end
end
