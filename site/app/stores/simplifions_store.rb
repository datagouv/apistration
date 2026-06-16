class SimplifionsStore
  GRIST_BASE_URL = 'https://grist.numerique.gouv.fr/api/docs/ofSVjCSAnMb6/tables'.freeze
  CACHE_KEY = 'simplifions_store/endpoint_links'.freeze
  SIMPLIFIONS_BASE_URL = 'https://simplifions.data.gouv.fr/cas-d-usages'.freeze
  SOLUTION_IDS = { 'api_particulier' => 1, 'api_entreprise' => 2 }.freeze

  def self.links_for(endpoint_uid, api:)
    (data["#{api}:#{endpoint_uid}"] || []).sort_by { |l| l[:name] }
  end

  def self.all_use_cases(api:)
    data.each_with_object([]) { |(key, links), memo|
      next unless key.start_with?("#{api}:")

      memo.concat(links)
    }.uniq { |l| l[:url] }.sort_by { |l| l[:name] }
  end

  def self.reset_cache!
    Rails.cache.delete(CACHE_KEY)
    @process_cache = nil
  end

  private_class_method def self.data
    if Rails.cache.is_a?(ActiveSupport::Cache::NullStore)
      @process_cache ||= build_mapping
    else
      Rails.cache.fetch(CACHE_KEY, expires_in: cache_ttl) { build_mapping }
    end
  rescue StandardError => e
    Rails.logger.error("SimplifionsStore: Grist fetch failed — #{e.message}")
    {}
  end

  private_class_method def self.cache_ttl
    ENV.fetch('SIMPLIFIONS_CACHE_TTL_MINUTES', '15').to_i.minutes
  end

  private_class_method def self.build_mapping
    uid_mapping = load_uid_mapping
    apis_by_id = fetch_table('APIs_et_datasets').index_by { |r| r['id'] }
    cas_usages_by_id = fetch_table('Cas_d_usages').index_by { |r| r['id'] }
    fournisseurs_by_id = fetch_table('Fournisseurs_de_services').index_by { |r| r['id'] }
    usagers_by_id = fetch_table('Usagers').index_by { |r| r['id'] }

    result = {}

    fetch_table('API_et_datasets_fournis').each do |record|
      fields = record['fields']
      api = SOLUTION_IDS.key(fields['Solution_fournisseur'])
      next unless api

      uid_datagouv = apis_by_id.dig(fields['API_ou_dataset_fourni'], 'fields', 'UID_datagouv')
      rails_uids = uid_mapping.dig(api, uid_datagouv).presence || []

      links = parse_grist_list(fields['Utile_pour_les_cas_d_usages']).filter_map do |cas_usage_id|
        cas_usage_fields = cas_usages_by_id.dig(cas_usage_id, 'fields')
        next unless cas_usage_fields&.fetch('Visible_sur_simplifions', false)

        build_link_for(cas_usage_fields, fournisseurs_by_id, usagers_by_id)
      end

      rails_uids.each do |rails_uid|
        key = "#{api}:#{rails_uid}"
        result[key] = (result[key] || []).concat(links).uniq { |l| l[:url] }
      end
    end

    result
  end

  private_class_method def self.build_link_for(cas_usage_fields, fournisseurs_by_id, usagers_by_id)
    nom = cas_usage_fields['Nom']
    administrations = parse_grist_list(cas_usage_fields['A_destination_de']).filter_map do |id|
      fournisseurs_by_id.dig(id, 'fields', 'Label')
    end
    public_cible = parse_grist_list(cas_usage_fields['Pour_simplifier_les_demarches_de']).filter_map do |id|
      usagers_by_id.dig(id, 'fields', 'Label')
    end

    {
      name: nom,
      url: "#{SIMPLIFIONS_BASE_URL}/#{nom.parameterize}",
      description: cas_usage_fields['Description_courte'],
      icon: cas_usage_fields['Icone_du_titre'],
      administrations: administrations,
      public_cible: public_cible
    }
  end

  private_class_method def self.load_uid_mapping
    YAML.load_file(Rails.root.join('config/grist_datagouv_uid_mapping.yml'))
  end

  private_class_method def self.fetch_table(table_name)
    response = faraday_connection.get("#{GRIST_BASE_URL}/#{table_name}/records")
    JSON.parse(response.body)['records']
  end

  private_class_method def self.faraday_connection
    Faraday.new(headers: { 'User-Agent' => 'APIEntreprise-site/1.0' }) do |f|
      f.request :retry, max: 1, interval: 1
      f.response :raise_error
      f.adapter :net_http
    end
  end

  private_class_method def self.parse_grist_list(value)
    return [] unless value.is_a?(Array)

    value.reject { |v| v == 'L' }.map(&:to_i)
  end
end
