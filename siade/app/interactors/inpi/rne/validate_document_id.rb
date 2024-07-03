class INPI::RNE::ValidateDocumentId < ValidateParamInteractor
  def call
    return if valid_rne_document_id?

    invalid_param!(:document_id)
  end

  private

  def valid_rne_document_id?
    document_id.present? &&
      document_id =~ rne_document_id_regex
  end

  def rne_document_id_regex
    /^[a-f0-9]{24}$/
  end

  def document_id
    context.params[:document_id]
  end
end
