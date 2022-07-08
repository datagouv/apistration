class DocumentsAssociationPolicy < APIPolicy
  def jwt_scope_tag
    'documents_association'
  end
end
