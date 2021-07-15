class JSONAPI::DocumentSerializer < JSONAPI::BaseSerializer
  def self.inherited(klass)
    klass.send(:set_type, :document)
    klass.send(:attributes, :document_url)
  end
end
