require 'singleton'

module Simplifions
  class Sitemap
    include Singleton

    SITEMAP_URL = 'https://simplifions.data.gouv.fr/sitemap.xml'.freeze
    CACHE_KEY = 'simplifions/sitemap/slugs'.freeze

    def slug_for(name)
      base_slug = slugify(name)
      return base_slug if slugs.blank? || slugs.include?(base_slug)

      suffixed_slugs = slugs.grep(/\A#{Regexp.escape(base_slug)}-\d+\z/)
      return suffixed_slugs.first if suffixed_slugs.one?

      Rails.logger.warn("Simplifions::Sitemap: ambiguous slug for #{name}") if suffixed_slugs.many?
      base_slug
    end

    def reset!
      Rails.cache.delete(CACHE_KEY)
      @process_cache = nil
      @faraday_connection = nil
    end

    private

    def slugs
      if Rails.cache.is_a?(ActiveSupport::Cache::NullStore)
        @process_cache ||= fetch_slugs
      else
        Rails.cache.fetch(CACHE_KEY, expires_in: cache_ttl) { fetch_slugs }
      end
    rescue StandardError => e
      Rails.logger.error("Simplifions::Sitemap: sitemap fetch failed - #{e.message}")
      []
    end

    def fetch_slugs
      document = Nokogiri::XML(faraday_connection.get(SITEMAP_URL).body)
      document.remove_namespaces!

      document.xpath('//url/loc').filter_map { |loc|
        loc.text[%r{/cas-d-usages/([^/?#]+)}, 1]
      }.uniq.sort
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

    def slugify(name)
      name.to_s.gsub(/[\u2018\u2019']/, '').gsub('€', 'eur').parameterize
    end
  end
end
