class CNAF::RetrieverOrganizer < RetrieverOrganizer
  def self.inherited(klass)
    super
    klass.class_eval do
      before do
        handles_dss_prestation_name
      end
    end
  end

  private

  def handles_dss_prestation_name
    context.dss_prestation_name = dss_prestation_name
  end
end
