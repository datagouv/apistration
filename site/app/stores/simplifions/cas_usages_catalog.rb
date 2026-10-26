module Simplifions
  class CasUsagesCatalog
    SIMPLIFIONS_BASE_URL = 'https://simplifions.data.gouv.fr/demarches'.freeze
    SOLUTION_IDS = { 'api_particulier' => 1, 'api_entreprise' => 2 }.freeze

    def self.build
      new(tables: GristClient.new.tables, sitemap: Sitemap.fetch).build
    end

    def initialize(tables:, sitemap:)
      @tables = tables
      @sitemap = sitemap
      @indexes = tables.transform_values { |records| records.index_by { |record| record['id'] } }
    end

    def build
      SOLUTION_IDS.transform_values do |solution|
        records = fourni_records(solution)

        {
          'all' => cas_usages_from(records),
          'by_datagouv_uid' => records.group_by { |record| datagouv_uid_for(record) }
            .except(nil)
            .transform_values { |uid_records| cas_usages_from(uid_records) }
        }
      end
    end

    private

    def fourni_records(solution)
      @tables.fetch(:fournis, []).select do |record|
        record.dig('fields', 'Solution_fournisseur') == solution
      end
    end

    def datagouv_uid_for(record)
      @indexes.dig(:apis, record.dig('fields', 'API_ou_dataset_fourni'), 'fields', 'UID_datagouv')
    end

    def cas_usages_from(records)
      records.flat_map { |record| cas_usages_from_record(record) }
        .uniq { |cas_usage| cas_usage['name'] }
        .sort_by { |cas_usage| cas_usage['name'].to_s }
    end

    def cas_usages_from_record(record)
      parse_grist_list(record.dig('fields', 'Utile_pour_les_cas_d_usages')).filter_map do |cas_usage_id|
        fields = @indexes.dig(:cas_usages, cas_usage_id, 'fields')
        next unless fields&.fetch('Visible_sur_simplifions', false)

        build_cas_usage(fields)
      end
    end

    def build_cas_usage(fields)
      {
        'name' => fields['Nom'],
        'description' => fields['Description_courte'],
        'icon' => fields['Icone_du_titre'],
        'administrations' => labels_for(fields['A_destination_de'], :fournisseurs),
        'public_cible' => labels_for(fields['Pour_simplifier_les_demarches_de'], :usagers),
        'url' => "#{SIMPLIFIONS_BASE_URL}/#{@sitemap.slug_for(fields['Nom'])}"
      }
    end

    def labels_for(value, table_key)
      parse_grist_list(value).filter_map do |id|
        @indexes.dig(table_key, id, 'fields', 'Label')
      end
    end

    def parse_grist_list(value)
      return [] unless [*value] == value

      value.reject { |item| item == 'L' }.map(&:to_i)
    end
  end
end
