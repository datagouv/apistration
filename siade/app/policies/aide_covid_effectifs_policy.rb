class AideCovidEffectifsPolicy < APIPolicy
  def user_authorized?
    true
  end

  def jwt_role_tag
    'aides_covid_effectifs'
  end
end
