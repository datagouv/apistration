class MI::Associations::Documents::BuildResourceCollection < BuildResourceCollection
  def items
    context.uploaded_collection
  end

  def items_meta
    {
      nombre_documents: context.total_documents,
      nombre_documents_deficients: context.upload_errors
    }
  end

  def resource_attributes(doc)
    {
      id: doc[:id],
      timestamp: doc[:time],
      url: doc[:hosted_url],
      expires_in: doc[:url_expires_in],
      type: doc[:lib_sous_type],
      errors: doc[:errors]
    }
  end
end
