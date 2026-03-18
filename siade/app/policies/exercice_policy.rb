class ExercicePolicy < APIPolicy
  def jwt_role_tag
    'exercices'
  end
end
