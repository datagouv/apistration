class CNAV::RetrieverOrganizer < RetrieverOrganizer
  REGIME_CODE_MSA = '00171001'.freeze
  REGIME_CODE_CNAF = '00810011'.freeze
  REGIME_CODE_RNCPS = '99430000'.freeze

  REGIME_CODE_LABEL = {
    REGIME_CODE_MSA => 'MSA',
    REGIME_CODE_CNAF => 'CNAF',
    REGIME_CODE_RNCPS => 'RNCPS'
  }.freeze

  REGIME_CODE_FROM_LABEL = REGIME_CODE_LABEL.invert.freeze

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
