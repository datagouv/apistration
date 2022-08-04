class APIParticulier::V2BaseSerializer < ActiveModel::Serializer
  def scope?(scope_name)
    current_user.scopes.include?(scope_name.to_s)
  end
end
