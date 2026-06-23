require 'singleton'

module Simplifions
  class GristClient
    include Singleton

    GRIST_BASE_URL = 'https://grist.numerique.gouv.fr/api/docs/ofSVjCSAnMb6/tables'.freeze
    CACHE_KEY = 'simplifions/grist_client/tables'.freeze
    SOLUTION_IDS = { 'api_particulier' => 1, 'api_entreprise' => 2 }.freeze

    def cas_usages_for_solution(api)
      return [] unless solution_id(api)

      fourni_records(api).flat_map { |record| cas_usages_from_record(record) }.uniq { |cas_usage| cas_usage[:name] }
    end

    def cas_usages_for_datagouv_uid(datagouv_uid, api)
      return [] unless solution_id(api)

      fourni_records(api)
        .select { |record| datagouv_uid_for_record(record) == datagouv_uid }
        .flat_map { |record| cas_usages_from_record(record) }
        .uniq { |cas_usage| cas_usage[:name] }
    end

    def reset!
      Rails.cache.delete(CACHE_KEY)
      @process_cache = nil
      @faraday_connection = nil
    end

    private

    def fourni_records(api)
      tables.fetch(:fournis, []).select do |record|
        record.dig('fields', 'Solution_fournisseur') == solution_id(api)
      end
    end

    def datagouv_uid_for_record(record)
      api_dataset_id = record.dig('fields', 'API_ou_dataset_fourni')

      apis_by_id.dig(api_dataset_id, 'fields', 'UID_datagouv')
    end

    def cas_usages_from_record(record)
      parse_grist_list(record.dig('fields', 'Utile_pour_les_cas_d_usages')).filter_map do |cas_usage_id|
        fields = cas_usages_by_id.dig(cas_usage_id, 'fields')
        next unless fields&.fetch('Visible_sur_simplifions', false)

        build_cas_usage(fields)
      end
    end

    def build_cas_usage(fields)
      {
        name: fields['Nom'],
        description: fields['Description_courte'],
        icon: fields['Icone_du_titre'],
        administrations: labels_for(fields['A_destination_de'], fournisseurs_by_id),
        public_cible: labels_for(fields['Pour_simplifier_les_demarches_de'], usagers_by_id)
      }
    end

    def labels_for(value, indexed_table)
      parse_grist_list(value).filter_map do |id|
        indexed_table.dig(id, 'fields', 'Label')
      end
    end

    def solution_id(api)
      SOLUTION_IDS[api]
    end

    def tables
      if Rails.cache.is_a?(ActiveSupport::Cache::NullStore)
        @process_cache ||= fetch_tables
      else
        Rails.cache.fetch(CACHE_KEY, expires_in: cache_ttl) { fetch_tables }
      end
    rescue StandardError => e
      Rails.logger.error("Simplifions::GristClient: Grist fetch failed - #{e.message}")
      {}
    end

    def fetch_tables
      {
        fournis: fetch_table('API_et_datasets_fournis'),
        apis: fetch_table('APIs_et_datasets'),
        cas_usages: fetch_table('Cas_d_usages'),
        fournisseurs: fetch_table('Fournisseurs_de_services'),
        usagers: fetch_table('Usagers')
      }
    end

    def apis_by_id
      tables.fetch(:apis, []).index_by { |record| record['id'] }
    end

    def cas_usages_by_id
      tables.fetch(:cas_usages, []).index_by { |record| record['id'] }
    end

    def fournisseurs_by_id
      tables.fetch(:fournisseurs, []).index_by { |record| record['id'] }
    end

    def usagers_by_id
      tables.fetch(:usagers, []).index_by { |record| record['id'] }
    end

    def fetch_table(table_name)
      response = faraday_connection.get("#{GRIST_BASE_URL}/#{table_name}/records")

      JSON.parse(response.body).fetch('records', [])
    end

    def faraday_connection
      @faraday_connection ||= Faraday.new(headers: { 'User-Agent' => 'APIEntreprise-site/1.0' }) do |f|
        f.request :retry, max: 1, interval: 1
        f.response :raise_error
        f.adapter :net_http
        f.options.open_timeout = 2
        f.options.timeout = 5
      end
    end

    def cache_ttl
      ENV.fetch('SIMPLIFIONS_CACHE_TTL_MINUTES', '15').to_i.minutes
    end

    def parse_grist_list(value)
      return [] unless value.is_a?(Array)

      value.reject { |item| item == 'L' }.map(&:to_i)
    end
  end
end
