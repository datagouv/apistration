RSpec.describe Provider::ConsumersCsvFormatter do
  let(:row) do
    {
      external_id: 'ext-1',
      public_id: 'pub-1',
      siret: '12345678900010',
      intitule: 'Demande X',
      email: 'demandeur@example.org',
      denomination: 'ACME',
      total: 42,
      unique: 17
    }
  end

  it 'maps consumer row fields into CSV columns' do
    csv = described_class.new([row]).to_csv
    expect(csv).to include('ext-1;Demande X;demandeur@example.org;12345678900010;ACME;42;17')
  end

  it 'translates headers from provider.dashboard.consumers_csv scope' do
    csv = described_class.new([]).to_csv
    expect(csv).to include('DataPass ID;Intitulé;Email demandeur;SIRET;Raison sociale;Total;Unique')
  end
end
