require 'singleton'

module Simplifions
  class Sitemap
    include Singleton
    include RemoteCache

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

    private

    def slugs
      cached { fetch_slugs }
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

    def slugify(name)
      name.to_s.gsub(/[\u2018\u2019']/, '').gsub('€', 'eur').parameterize
    end
  end
end
