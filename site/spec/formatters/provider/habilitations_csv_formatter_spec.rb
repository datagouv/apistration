RSpec.describe Provider::HabilitationsCsvFormatter do
  let(:row) do
    {
      external_id: 'ext-1',
      public_id: 'pub-1',
      intitule: 'Demande X',
      siret: '12345678900010',
      status: 'validated',
      scopes: %w[scope_a scope_b],
      email: 'demandeur@example.org',
      denomination: 'ACME'
    }
  end

  it 'maps habilitation row fields into CSV columns' do
    csv = described_class.new([row]).to_csv
    expect(csv).to include('ext-1;Demande X;12345678900010;ACME;demandeur@example.org;Validée;scope_a|scope_b')
  end

  it 'translates headers from formatters.provider.habilitations_csv scope' do
    csv = described_class.new([]).to_csv
    expect(csv).to include('DataPass ID;Intitulé;SIRET;Raison sociale;Email demandeur;Statut;Scopes')
  end

  it 'falls back to raw status when translation is missing' do
    csv = described_class.new([row.merge(status: 'unknown_status')]).to_csv
    expect(csv).to include('unknown_status')
  end
end
