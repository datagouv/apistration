require 'singleton'

class SimplifionsStore
  include Singleton

  SIMPLIFIONS_BASE_URL = 'https://simplifions.data.gouv.fr/cas-d-usages'.freeze

  def all(api:)
    grist.cas_usages_for_solution(api)
      .map { |record| build_cas_usage(record, api) }
      .sort_by { |cas_usage| cas_usage.name.to_s }
  end

  def for_endpoint(endpoint_uid, api:)
    datagouv_uid = endpoints_by_uid(api)[endpoint_uid]&.datagouv_uid
    return [] if datagouv_uid.blank?

    grist.cas_usages_for_datagouv_uid(datagouv_uid, api)
      .map { |record| build_cas_usage(record, api) }
      .sort_by { |cas_usage| cas_usage.name.to_s }
  end

  def reset!
    Simplifions::GristClient.instance.reset!
    Simplifions::Sitemap.instance.reset!
    @grist = nil
    @sitemap = nil
    @endpoints_by_uid = nil
  end

  private

  def grist
    @grist ||= Simplifions::GristClient.instance
  end

  def sitemap
    @sitemap ||= Simplifions::Sitemap.instance
  end

  def endpoints_by_uid(api)
    @endpoints_by_uid ||= {}
    @endpoints_by_uid[api] ||= "#{api.classify}::Endpoint".constantize.all.index_by(&:uid)
  end

  def build_cas_usage(record, api)
    "#{api.classify}::CasUsage".constantize.new(
      record.merge(url: "#{SIMPLIFIONS_BASE_URL}/#{sitemap.slug_for(record[:name])}")
    )
  end
end
