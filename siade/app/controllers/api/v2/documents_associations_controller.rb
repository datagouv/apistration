require 'open-uri'

class API::V2::DocumentsAssociationsController < API::AuthenticateEntityController
  def show
    authorize :documents_association

    retrieve_documents_asso = SIADE::V2::Retrievers::DocumentsAssociations.new(association_id_from_params)
    retrieve_documents_asso.retrieve

    if retrieve_documents_asso.success?
      @documents = DocumentRNACollectionFromPayloads.new(retrieve_documents_asso.association_id, retrieve_documents_asso.documents)
      @documents.clean_and_rehost!

      render json: {
        documents:                   @documents.payload_collection,
        nombre_documents:            @documents.payload_collection.size,
        nombre_documents_deficients: @documents.nombre_documents_deficients
      }, status: extract_best_http_status(@documents, retrieve_documents_asso.http_code)
    else
      render_errors(retrieve_documents_asso)
    end
  end

  def association_id_from_params
    params.require(:id)
  end

  private

  def extract_best_http_status(documents, retriever_http_code)
    return retriever_http_code unless retriever_http_code == 200

    if documents.nombre_documents_deficients > 0
      206
    else
      200
    end
  end

  class DocumentRNACollectionFromPayloads
    def initialize(association_id, payloads)
      @association_id = association_id
      @collection = payloads.map { |p| DocumentRNA.new(p) }
      @nombre_documents_total = @collection.size
      @clean = false
    end

    def clean_and_rehost!
      @collection.tap do |c|
        c.each(&:rehost!)
        c.reject!(&:error?)

        @clean = true
      end
    end

    def payload_collection
      clean_and_rehost! unless @clean
      @payload_collection ||= @collection.map(&:payload)
    end

    def nombre_documents_deficients
      @nombre_documents_deficients ||= begin
        nombre_deficients = @nombre_documents_total - payload_collection.size
        Rails.logger.error "#{nombre_deficients} documents sont déficients pour l'association #{@association_id}" unless nombre_deficients.zero?

        nombre_deficients
      end
    end
  end

  class DocumentRNA
    attr_reader :payload

    def initialize(payload)
      @payload = payload
      @rna_url = payload['url']
      @error = false
    end

    def error?
      @error
    end

    def rehost!
      pdf_uploader = SIADE::SelfHostedDocument::File::PDF.new('document_asso', decrypt: true)
      pdf_uploader.store_from_url(@rna_url)
      if pdf_uploader.success?
        @payload['url'] = pdf_uploader.url
      else
        @error = true
      end
      self
    end
  end
end
