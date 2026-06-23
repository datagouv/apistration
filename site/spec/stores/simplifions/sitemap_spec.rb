# frozen_string_literal: true

RSpec.describe Simplifions::Sitemap, type: :store do
  let(:sitemap_url) { 'https://simplifions.data.gouv.fr/sitemap.xml' }

  before do
    described_class.instance.reset!
  end

  describe '#slug_for' do
    it 'uses the sitemap suffix when parameterized name is deduplicated by simplifions' do
      stub_request(:get, sitemap_url).to_return(
        body: <<~XML
          <?xml version="1.0" encoding="UTF-8"?>
          <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
            <url><loc>https://simplifions.data.gouv.fr/cas-d-usages/tarification-du-stationnement-residentiel-attribution-1</loc></url>
          </urlset>
        XML
      )

      expect(described_class.instance.slug_for('Tarification du stationnement résidentiel : attribution')).to eq(
        'tarification-du-stationnement-residentiel-attribution-1'
      )
    end

    it 'falls back to parameterized name when sitemap is unavailable' do
      stub_request(:get, sitemap_url).to_raise(Faraday::Error)

      expect(described_class.instance.slug_for('Tarification cantine scolaire à 1€')).to eq(
        'tarification-cantine-scolaire-a-1eur'
      )
    end
  end
end
