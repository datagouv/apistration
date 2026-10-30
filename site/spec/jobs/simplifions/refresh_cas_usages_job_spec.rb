# frozen_string_literal: true

RSpec.describe Simplifions::RefreshCasUsagesJob do
  subject(:refresh) { described_class.perform_now }

  let(:quotient_familial_cas_usages) { APIParticulier::CasUsage.for_endpoint('cnav/quotient_familial') }

  describe 'when Grist and the simplifions sitemap respond' do
    before { stub_simplifions }

    it 'serves the visible cas usages of the endpoint dataset, linked to simplifions' do
      refresh

      expect(quotient_familial_cas_usages).to contain_exactly(
        have_attributes(
          name: 'Tarification cantine scolaire à 1€',
          url: 'https://simplifions.data.gouv.fr/demarches/tarification-cantine-scolaire-a-1eur',
          description: 'Calculez le tarif automatiquement.',
          icon: '🏫',
          administrations: ['Communes et groupements de communes'],
          public_cible: ['Entreprises']
        )
      )
    end

    it 'serves every visible cas usage of the API, even those whose dataset has no endpoint page' do
      refresh

      expect(APIParticulier::CasUsage.all.map(&:name)).to eq(
        ['Cas visible sans fiche Rails', 'Tarification cantine scolaire à 1€']
      )
    end

    it 'serves them to web processes booted at another time than the worker' do
      default_namespace = Rails.cache.options[:namespace]
      Rails.cache.options[:namespace] = 'worker_booted_at_1'
      refresh
      Rails.cache.options[:namespace] = 'web_booted_at_2'

      expect(quotient_familial_cas_usages.map(&:name)).to eq(['Tarification cantine scolaire à 1€'])
    ensure
      Rails.cache.options[:namespace] = default_namespace
    end

    it 'serves no cas usage for an API without any in Grist' do
      refresh

      expect(APIEntreprise::CasUsage.all).to eq([])
    end
  end

  describe 'when simplifions deduplicated the slug of a cas usage' do
    before { stub_simplifions(sitemap_slugs: %w[tarification-cantine-scolaire-a-1eur-1]) }

    it 'links to the suffixed slug published in the sitemap' do
      refresh

      expect(quotient_familial_cas_usages.map(&:url)).to eq(
        ['https://simplifions.data.gouv.fr/demarches/tarification-cantine-scolaire-a-1eur-1']
      )
    end
  end

  describe 'when a visible cas usage has no name' do
    before do
      stub_simplifions(cas_usages: [
        { 'id' => 10, 'fields' => { 'Visible_sur_simplifions' => true, 'Nom' => 'Avec nom' } },
        { 'id' => 12, 'fields' => { 'Visible_sur_simplifions' => true, 'Nom' => nil } }
      ])
    end

    it 'still refreshes the cas usages' do
      refresh

      expect(APIParticulier::CasUsage.all.map(&:name)).to include('Avec nom')
    end
  end

  {
    'Grist fails' => :stub_simplifions_grist_failure,
    'Grist answers without records' => :stub_simplifions_grist_without_records,
    'the simplifions sitemap lists no cas usage' => :stub_simplifions_sitemap_error_page,
    'the simplifions sitemap is truncated' => :stub_simplifions_truncated_sitemap
  }.each do |failure, stub_failure|
    describe "when #{failure} after a successful refresh" do
      before do
        stub_simplifions(sitemap_slugs: %w[tarification-cantine-scolaire-a-1eur-1])
        described_class.perform_now
        send(stub_failure)
      end

      it 'raises once its retries are exhausted so the failure reaches Sentry' do
        expect { perform_with_retries(described_class) }.to raise_error(StandardError)
      end

      it 'keeps serving the previously refreshed cas usages' do
        begin
          refresh
        rescue StandardError
          nil
        end

        expect(quotient_familial_cas_usages.map(&:url)).to eq(
          ['https://simplifions.data.gouv.fr/demarches/tarification-cantine-scolaire-a-1eur-1']
        )
      end
    end
  end
end
