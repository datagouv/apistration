class MI::Associations::Documents::BuildResourceCollection < BuildResourceCollection
  def items
    raw_documents
  end

  def items_context
    {
      nombre_documents: raw_documents.count,
      nombre_documents_deficients: 0
    }
  end

  def resource_attributes(raw_document)
    {
      id: raw_document[:id],
      timestamp: raw_document[:time],
      url: raw_document[:url],
      expires_in: 1.day.to_i,
      type: raw_document[:lib_sous_type],
      errors: []
    }
  end

  def raw_documents
    items = xml_body_as_hash[:asso][:documents][:document_rna]

    case items
    in Hash
      [items]
    in Array
      items.flatten
    end
  end
end
