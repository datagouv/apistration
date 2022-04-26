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

      if upload.success?
        item[:hosted_url] = upload.url
        uploaded_collection << item
      else
        context.upload_errors += 1
      end
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
end
