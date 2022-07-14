require 'open-uri'

class API::V2::DocumentsAssociationsController < API::V2::BaseController
  attr_reader :organizer

  def show
    authorize :documents_association

    @organizer = ::MI::Associations::Documents.call(params: organizer_params)

    if organizer.success?
      render json: serialized_data(organizer),
        status: extract_http_code(organizer)
    else
      render json: ErrorsSerializer.new(organizer.errors, format: error_format).as_json,
        status: extract_http_code(organizer)
    end
  end

  private

  def serialized_data(organizer)
    {
      documents: organizer.bundled_data.data.map do |document_resource|
        {
          type: document_resource.type,
          url: document_resource.url,
          timestamp: document_resource.timestamp
        }
      end,
      nombre_documents: organizer.total_documents,
      nombre_documents_deficients: organizer.upload_errors
    }
  end

  def organizer_params
    {
      siret_or_rna: params.require(:id)
    }
  end
end
