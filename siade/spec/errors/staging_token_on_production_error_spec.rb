RSpec.describe StagingTokenOnProductionError, type: :error do
  it_behaves_like 'a valid error'

  describe '#detail' do
    it 'points to the API Entreprise staging host' do
      expect(described_class.new('api_entreprise').detail).to include('staging.entreprise.api.gouv.fr')
    end

    it 'points to the API Particulier staging host' do
      expect(described_class.new('api_particulier').detail).to include('staging.particulier.api.gouv.fr')
    end

    it 'falls back to a generic message' do
      expect(described_class.new.detail).to include("l'environnement de staging")
    end
  end
end
