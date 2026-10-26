require 'singleton'

class SimplifionsStore
  include Singleton
  include Simplifions::RemoteCache

  CACHE_KEY = 'simplifions/cas_usages'.freeze

  def all(api:)
    build_cas_usages(catalog_for(api)['all'], api)
  end

  def for_endpoint(endpoint_uid, api:)
    datagouv_uid = endpoints_by_uid(api)[endpoint_uid]&.datagouv_uid
    return [] if datagouv_uid.blank?

    build_cas_usages(catalog_for(api).dig('by_datagouv_uid', datagouv_uid), api)
  end

  private

  def catalog_for(api)
    cached { Simplifions::CasUsagesCatalog.build }.fetch(api, {})
  rescue StandardError => e
    Rails.logger.error("SimplifionsStore: cas usages build failed - #{e.message}")
    {}
  end

  def endpoints_by_uid(api)
    @endpoints_by_uid ||= {}
    @endpoints_by_uid[api] ||= "#{api.classify}::Endpoint".constantize.all.index_by(&:uid)
  end

  def build_cas_usages(records, api)
    (records || []).map { |record| "#{api.classify}::CasUsage".constantize.new(record) }
  end
end
