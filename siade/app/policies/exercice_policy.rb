class ExercicePolicy < APIPolicy
  def jwt_scope_tag
    'exercices'
  end
end
