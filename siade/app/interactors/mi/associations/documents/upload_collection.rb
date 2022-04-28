class MI::Associations::Documents::UploadCollection < ApplicationInteractor
  include ResourceHelpers

  before do
    context.uploaded_collection = []
    context.total_documents = raw_items.size
    context.upload_errors = 0
  end

  def call
    raw_items.each_with_object(context.uploaded_collection) do |item, uploaded_collection|
      upload = MI::Associations::Documents::Upload.call(url: item[:url])

      uploaded_collection << document_with_upload_metadata(item, upload)
    end
  end

  private

  def raw_items
    items = xml_body_as_hash[:asso][:documents][:document_rna]

    case items
    in Hash
      [items]
    in Array
      items.flatten
    end
  end

  def document_with_upload_metadata(doc, upload)
    if upload.success?
      retrieve_upload_metadata(doc, upload)
    else
      process_error(doc, upload)
    end
  end

  def retrieve_upload_metadata(item, uploader)
    item.merge({
      hosted_url: uploader.url,
      url_expires_in: uploader.url_expires_in,
      errors: []
    })
  end

  def upload_errors_msg(uploader)
    uploader.errors.map(&:detail)
  end

  def process_error(item, uploader)
    context.upload_errors += 1

    item.merge({
      errors: upload_errors_msg(uploader),
      hosted_url: 'Non disponible',
      url_expires_in: nil
    })
  end
end
