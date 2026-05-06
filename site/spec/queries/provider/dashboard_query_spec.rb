RSpec.describe Provider::DashboardQuery do
  subject(:query) { described_class.new(provider, filter) }

  let(:provider) { APIEntreprise::Provider.find('insee') }
  let(:filter) { Provider::DashboardFilter.new(provider, 'entreprise') }

  let(:insee_etablissements) { 'api_entreprise/v3_and_more/insee/etablissements' }
  let(:insee_unites) { 'api_entreprise/v3_and_more/insee/unites_legales' }
  let(:dgfip_chiffres) { 'api_entreprise/v3_and_more/dgfip/chiffres_affaires' }

  before do
    create(:access_log, controller: insee_etablissements, status: '200', api_version: 'v3', cached: false, duration: '500')
    create(:access_log, controller: insee_etablissements, status: '404', api_version: 'v3', cached: true, duration: '300')
    create(:access_log, controller: insee_etablissements, status: '502', api_version: 'v3', cached: false, duration: '700')
    create(:access_log, controller: insee_unites, status: '200', api_version: 'v3', cached: false, duration: '120')
    create(:access_log, controller: dgfip_chiffres, status: '200', api_version: 'v3', cached: false, duration: '100')
  end

  describe 'scope' do
    it 'restricts totals to controllers declared by INSEE fiches' do
      expect(query.total_calls).to eq(4)
    end

    it 'counts unique calls' do
      expect(query.unique_calls).to eq(4)
    end

    it 'counts cached calls' do
      expect(query.cached_calls).to eq(1)
    end

    it 'ignores filter.routes outside the provider scope (cross-provider leakage guard)' do
      foreign = Provider::DashboardFilter.new(provider, 'entreprise', routes: [dgfip_chiffres])
      expect(described_class.new(provider, foreign).total_calls).to eq(0)
    end

    it 'narrows when filter.routes intersects the provider scope' do
      narrow = Provider::DashboardFilter.new(provider, 'entreprise', routes: [insee_etablissements])
      expect(described_class.new(provider, narrow).total_calls).to eq(3)
    end

    it 'excludes calls outside the date range' do
      old = Provider::DashboardFilter.new(provider, 'entreprise', date_from: 2.months.ago.to_date, date_to: 2.months.ago.to_date)
      expect(described_class.new(provider, old).total_calls).to eq(0)
    end
  end

  describe 'success breakdown' do
    subject(:breakdown) { query.success_breakdown }

    it 'aggregates 200 / 404 / provider errors' do
      expect(breakdown).to include(success: 2, not_found: 1, errors: 1, total: 4)
    end

    it 'tags v2 503/504 as provider errors' do
      create(:access_log, controller: insee_etablissements, status: '503', api_version: 'v2', cached: false, duration: '900')
      expect(query.success_breakdown[:errors]).to eq(2)
    end
  end

  describe 'duration' do
    it 'computes the weighted mean of avg_duration' do
      # Successful (200/404) durations: 500, 300, 120 -> weighted mean = 306.66
      expect(query.avg_duration).to be_within(0.01).of((500 + 300 + 120) / 3.0)
    end

    it 'weights duration by call volume across rows' do
      Timecop.freeze(2.days.ago.beginning_of_day) do
        create_list(:access_log, 8, controller: insee_etablissements, status: '200', api_version: 'v3', cached: false, duration: '1000')
      end
      # 1 row: today, avg≈306.66 weight=3 ; 1 row: 2 days ago, avg=1000 weight=8
      # weighted mean = (306.66*3 + 1000*8) / 11 ≈ 810.9, well above the unweighted (≈653)
      expect(query.avg_duration).to be > 800
    end
  end

  describe 'evolution' do
    it 'returns one entry per bucket with all metrics' do
      result = query.evolution
      expect(result).to be_an(Array)
      expect(result.first.keys).to contain_exactly(:bucket, :total, :unique, :cached)
      expect(result.sum { |r| r[:total] }).to eq(4)
    end

    it 'evolution_success splits per status' do
      result = query.evolution_success
      expect(result.first.keys).to contain_exactly(:bucket, :success, :not_found, :errors)
    end

    it 'avg_duration_evolution returns weighted bucket means' do
      result = query.avg_duration_evolution
      expect(result).to be_present
      expect(result.first[:value]).to be_within(0.01).of((500 + 300 + 120) / 3.0)
    end
  end

  describe 'per endpoint' do
    it 'groups by full controller and labels with the fiche title' do
      rows = query.per_endpoint
      expect(rows.pluck(:endpoint)).to contain_exactly('Données établissement', 'Données unité légale')
      expect(rows.find { |r| r[:endpoint] == 'Données établissement' }).to include(total: 3, cached: 1)
    end

    it 'success_per_endpoint splits per fiche' do
      rows = query.success_per_endpoint
      etabs = rows.find { |r| r[:endpoint] == 'Données établissement' }
      expect(etabs).to include(success: 1, not_found: 1, errors: 1)
    end

    it 'avg_duration_per_endpoint computes weighted means per fiche' do
      rows = query.avg_duration_per_endpoint
      etabs = rows.find { |r| r[:endpoint] == 'Données établissement' }
      # Only 200 and 404 contribute: (500 + 300) / 2 = 400
      expect(etabs[:value]).to be_within(0.01).of(400.0)
    end

    it 'evolution_per_endpoint_series builds chart-ready hashes with chronological buckets' do
      Timecop.freeze(2.days.ago.beginning_of_day) do
        create(:access_log, controller: insee_etablissements, status: '200', api_version: 'v3', cached: false, duration: '200')
      end

      formatter = ->(b) { b.to_s }
      series = query.evolution_per_endpoint_series(:total, &formatter)
      etabs = series.find { |s| s[:label] == 'Données établissement' }
      expect(etabs[:points].size).to eq(2)
      expect(etabs[:points].map(&:first)).to eq(etabs[:points].map(&:first).sort)
    end
  end

  describe 'consumers / habilitations' do
    let(:user) { create(:user, email: 'demandeur@example.com') }
    let(:authorization_request) do
      create(:authorization_request, :with_organization,
        intitule: 'Mairie de X',
        external_id: 'AR-1',
        api: 'entreprise',
        siret: '13002526500013',
        scopes: ['unites_legales_etablissements_insee'],
        status: :validated)
    end

    before do
      create(:user_authorization_request_role, user: user, authorization_request: authorization_request, role: 'demandeur')
      token = create(:token, authorization_request: authorization_request, intitule: 'Mairie de X')
      create(:access_log,
        controller: insee_etablissements, status: '200', api_version: 'v3', cached: false, duration: '500',
        token: token)
    end

    it 'lists consumers with their authorization request and demandeur email' do
      consumer = query.consumers.find { |c| c[:external_id] == 'AR-1' }
      expect(consumer).to include(intitule: 'Mairie de X', email: 'demandeur@example.com', siret: '13002526500013')
      expect(consumer[:total]).to be_positive
    end

    it 'lists habilitations matching the provider scopes' do
      hab = query.habilitations.find { |h| h[:external_id] == 'AR-1' }
      expect(hab).to include(intitule: 'Mairie de X', email: 'demandeur@example.com', siret: '13002526500013')
      expect(hab[:scopes]).to include('unites_legales_etablissements_insee')
    end

    it 'excludes draft and archived habilitations' do
      create(:authorization_request,
        intitule: 'Draft',
        external_id: 'AR-DRAFT',
        api: 'entreprise',
        siret: '13002526500013',
        scopes: ['unites_legales_etablissements_insee'],
        status: :draft)
      expect(query.habilitations.pluck(:external_id)).not_to include('AR-DRAFT')
    end
  end

  describe 'excluded controllers' do
    it 'ignores ping/uptime traffic' do
      create(:access_log, controller: 'uptime', status: '200', api_version: 'v3', cached: false, duration: '10')
      create(:access_log, controller: 'ping', status: '200', api_version: 'v3', cached: false, duration: '10')
      expect(query.total_calls).to eq(4)
    end
  end
end
