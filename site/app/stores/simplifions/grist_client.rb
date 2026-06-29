require 'singleton'

module Simplifions
  class GristClient
    include Singleton
    include RemoteCache

    GRIST_BASE_URL = 'https://grist.numerique.gouv.fr/api/docs/ofSVjCSAnMb6/tables'.freeze
    CACHE_KEY = 'simplifions/grist_client/tables'.freeze
    SOLUTION_IDS = { 'api_particulier' => 1, 'api_entreprise' => 2 }.freeze

    def cas_usages_for_solution(api)
      solution = solution_id(api)
      return [] unless solution

      with_fresh_tables { cas_usages_from(fourni_records(solution)) }
    end

    def cas_usages_for_datagouv_uid(datagouv_uid, api)
      solution = solution_id(api)
      return [] unless solution

      with_fresh_tables do
        records = fourni_records(solution).select { |record| datagouv_uid_for_record(record) == datagouv_uid }
        cas_usages_from(records)
      end
    end

    private

    def with_fresh_tables
      @tables = nil
      @indexes = {}
      yield
    end

    def cas_usages_from(records)
      records.flat_map { |record| cas_usages_from_record(record) }.uniq { |cas_usage| cas_usage[:name] }
    end

    def fourni_records(solution)
      tables.fetch(:fournis, []).select do |record|
        record.dig('fields', 'Solution_fournisseur') == solution
      end
    end

    def datagouv_uid_for_record(record)
      api_dataset_id = record.dig('fields', 'API_ou_dataset_fourni')

      index_by_id(:apis).dig(api_dataset_id, 'fields', 'UID_datagouv')
    end

    def cas_usages_from_record(record)
      parse_grist_list(record.dig('fields', 'Utile_pour_les_cas_d_usages')).filter_map do |cas_usage_id|
        fields = index_by_id(:cas_usages).dig(cas_usage_id, 'fields')
        next unless fields&.fetch('Visible_sur_simplifions', false)

        build_cas_usage(fields)
      end
    end

    def build_cas_usage(fields)
      {
        name: fields['Nom'],
        description: fields['Description_courte'],
        icon: fields['Icone_du_titre'],
        administrations: labels_for(fields['A_destination_de'], :fournisseurs),
        public_cible: labels_for(fields['Pour_simplifier_les_demarches_de'], :usagers)
      }
    end

    def labels_for(value, table_key)
      parse_grist_list(value).filter_map do |id|
        index_by_id(table_key).dig(id, 'fields', 'Label')
      end
    end

    def solution_id(api)
      SOLUTION_IDS[api]
    end

    def index_by_id(table_key)
      @indexes[table_key] ||= tables.fetch(table_key, []).index_by { |record| record['id'] }
    end

    def tables
      @tables ||= cached { fetch_tables }
    rescue StandardError => e
      Rails.logger.error("Simplifions::GristClient: Grist fetch failed - #{e.message}")
      @tables = {}
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

    def fetch_table(table_name)
      response = faraday_connection.get("#{GRIST_BASE_URL}/#{table_name}/records")

      JSON.parse(response.body).fetch('records', [])
    end

    def parse_grist_list(value)
      return [] unless [*value] == value

      value.reject { |item| item == 'L' }.map(&:to_i)
    end
  end
end
