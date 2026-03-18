class DocumentsAssociationPolicy < APIPolicy
  def jwt_role_tag
    'documents_association'
  end
end
