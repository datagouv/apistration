require 'singleton'

class SimplifionsStore
  include Singleton

  CACHE_KEY = 'simplifions/cas_usages'.freeze
  CACHE_NAMESPACE = 'simplifions'.freeze

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
    catalog = Rails.cache.read(CACHE_KEY, namespace: CACHE_NAMESPACE)

    if catalog.nil?
      enqueue_refresh
      return {}
    end

    catalog.fetch(api, {})
  end

  def enqueue_refresh
    Simplifions::RefreshCasUsagesJob.perform_later
  rescue StandardError => e
    Rails.logger.error("SimplifionsStore: cas usages refresh enqueue failed - #{e.message}")
  end

  def endpoints_by_uid(api)
    @endpoints_by_uid ||= {}
    @endpoints_by_uid[api] ||= "#{api.classify}::Endpoint".constantize.all.index_by(&:uid)
  end

  def build_cas_usages(records, api)
    (records || []).map { |record| "#{api.classify}::CasUsage".constantize.new(record) }
  end
end
