RSpec.describe SIADE::V2::Adapters::LiassesFiscalesDGFIP do
  let(:user_id) { 'mps@marche.com.123' }
  let(:siren) { '301028346' }
  let(:annee) { '2015' }

  before do
    @instance = SIADE::V2::Adapters::LiassesFiscalesDGFIP.new(user_id, siren, annee)
  end

  describe '.to_hash' do
    it 'returns an hash with correct key value' do
      result = @instance.to_hash
      expect(result).to has_existing_key_whose_value_eq(:userId, 'mps@marche.com.123')
      expect(result).to has_existing_key_whose_value_eq(:siren, siren)
      expect(result).to has_existing_key_whose_value_eq(:annee, annee)
    end
  end
end
