class V3AndMore::DocumentSerializer < V3AndMore::BaseSerializer
  def self.inherited(klass)
    klass.send(:set_type, :document)
    klass.send(:attributes, :document_url, :expires_in)
  end
end
