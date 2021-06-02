class JSONAPI::DocumentSerializer < JSONAPI::BaseSerializer
  def self.inherited(klass)
    klass.send(:set_type, :document)
  end

  attributes :document_url
end
