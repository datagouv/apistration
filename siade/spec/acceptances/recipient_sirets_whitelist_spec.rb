RSpec.describe 'Errors config file', type: :acceptance do
  let(:recipient_sirets_whitelist_config) { Rails.application.config_for('recipient_sirets_whitelist') }

  it 'is a valid' do
    expect {
      recipient_sirets_whitelist_config
    }.not_to raise_error
  end

  it 'is has at least a valid siret for each entry' do
    recipient_sirets_whitelist_config.each do |recipient_siret_data|
      expect(recipient_siret_data).to have_key(:siret)

      expect(Siret.new(recipient_siret_data[:siret])).to be_valid
    end
  end

  it 'has no duplicate sirets' do
    expect(recipient_sirets_whitelist_config.count).to eq(recipient_sirets_whitelist_config.pluck(:siret).uniq.count)
  end
end
