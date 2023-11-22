require 'generate_summary_csv'

RSpec.describe GenerateSummaryCSV do
  describe '#perform' do
    subject { described_class.new(operation_id).perform }

    let(:operation_id) { 'api_entreprise_v3_acoss_attestations_sociales' }

    it 'does not raise error' do
      expect { subject }.not_to raise_error
    end
  end
end

