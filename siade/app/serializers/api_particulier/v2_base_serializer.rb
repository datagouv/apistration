class APIParticulier::V2BaseSerializer < ActiveModel::Serializer
  def scope?(scope_name)
    current_user.scopes.include?(scope_name.to_s)
  end

  def one_of_scopes?(scope_names)
    current_user.scopes.intersect?(scope_names.map(&:to_s))
  end
end
