class CNAF::RetrieverOrganizer < RetrieverOrganizer
  def self.inherited(klass)
    super
    klass.class_eval do
      before do
        handles_prestation_name
      end
    end
  end

  private

  def handles_prestation_name
    context.prestation_name = prestation_name
  end
end
