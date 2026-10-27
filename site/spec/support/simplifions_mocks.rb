# frozen_string_literal: true

module SimplifionsMocks
  SIMPLIFIONS_GRIST_BASE_URL = 'https://grist.numerique.gouv.fr/api/docs/ofSVjCSAnMb6/tables'
  SIMPLIFIONS_SITEMAP_URL = 'https://simplifions.data.gouv.fr/sitemap.xml'

  def stub_simplifions(cas_usages: simplifions_cas_usages_records, sitemap_slugs: simplifions_sitemap_slugs)
    stub_simplifions_table('APIs_et_datasets', simplifions_apis_records)
    stub_simplifions_table('Cas_d_usages', cas_usages)
    stub_simplifions_table('API_et_datasets_fournis', simplifions_fournis_records)
    stub_simplifions_table('Fournisseurs_de_services', [{ 'id' => 1, 'fields' => { 'Label' => 'Communes et groupements de communes' } }])
    stub_simplifions_table('Usagers', [{ 'id' => 2, 'fields' => { 'Label' => 'Entreprises' } }])
    stub_request(:get, SIMPLIFIONS_SITEMAP_URL).to_return(body: simplifions_sitemap(sitemap_slugs))
  end

  def stub_simplifions_grist_failure
    stub_request(:get, /grist\.numerique\.gouv\.fr/).to_return(status: 503)
  end

  def stub_simplifions_grist_without_records
    stub_request(:get, /grist\.numerique\.gouv\.fr/).to_return(body: {}.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  def stub_simplifions_sitemap_error_page
    stub_request(:get, SIMPLIFIONS_SITEMAP_URL).to_return(body: '<html><body>Maintenance</body></html>')
  end

  def stub_simplifions_truncated_sitemap
    stub_request(:get, SIMPLIFIONS_SITEMAP_URL).to_return(
      body: simplifions_sitemap(%w[cas-visible-sans-fiche-rails]).sub('</urlset>', '<url><loc>https://simplifions')
    )
  end

  private

  def stub_simplifions_table(table_name, records)
    stub_request(:get, "#{SIMPLIFIONS_GRIST_BASE_URL}/#{table_name}/records").to_return(
      body: { 'records' => records }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def simplifions_sitemap(slugs)
    urls = slugs.map { |slug| "<url><loc>https://simplifions.data.gouv.fr/demarches/#{slug}</loc></url>" }

    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">#{urls.join}</urlset>
    XML
  end

  def simplifions_sitemap_slugs
    %w[tarification-cantine-scolaire-a-1eur cas-visible-sans-fiche-rails]
  end

  def simplifions_apis_records
    [
      { 'id' => 1, 'fields' => { 'UID_datagouv' => '672cf982fcc8065be6e66f54', 'Nom' => 'API Quotient familial' } },
      { 'id' => 2, 'fields' => { 'UID_datagouv' => 'uid-not-declared-in-rails', 'Nom' => 'API non mappée Rails' } }
    ]
  end

  def simplifions_fournis_records
    [
      { 'id' => 1, 'fields' => { 'Solution_fournisseur' => 1, 'API_ou_dataset_fourni' => 1, 'Utile_pour_les_cas_d_usages' => ['L', 10, 11] } },
      { 'id' => 2, 'fields' => { 'Solution_fournisseur' => 1, 'API_ou_dataset_fourni' => 2, 'Utile_pour_les_cas_d_usages' => ['L', 12] } }
    ]
  end

  def simplifions_cas_usages_records
    [
      {
        'id' => 10,
        'fields' => {
          'Visible_sur_simplifions' => true,
          'Nom' => 'Tarification cantine scolaire à 1€',
          'Description_courte' => 'Calculez le tarif automatiquement.',
          'Icone_du_titre' => '🏫',
          'A_destination_de' => ['L', 1],
          'Pour_simplifier_les_demarches_de' => ['L', 2]
        }
      },
      { 'id' => 11, 'fields' => { 'Visible_sur_simplifions' => false, 'Nom' => 'Cas non visible' } },
      {
        'id' => 12,
        'fields' => {
          'Visible_sur_simplifions' => true,
          'Nom' => 'Cas visible sans fiche Rails',
          'Description_courte' => 'Visible via la solution.',
          'A_destination_de' => ['L'],
          'Pour_simplifier_les_demarches_de' => ['L']
        }
      }
    ]
  end
end
