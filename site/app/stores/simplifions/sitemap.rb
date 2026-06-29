require 'singleton'

module Simplifions
  class Sitemap
    include Singleton
    include RemoteCache

    SITEMAP_URL = 'https://simplifions.data.gouv.fr/sitemap.xml'.freeze
    CACHE_KEY = 'simplifions/sitemap/slugs'.freeze

    LEFT_SINGLE_QUOTATION_MARK = '‘'.freeze
    RIGHT_SINGLE_QUOTATION_MARK = '’'.freeze
    APOSTROPHE = "'".freeze
    QUOTES_TO_STRIP = /[#{LEFT_SINGLE_QUOTATION_MARK}#{RIGHT_SINGLE_QUOTATION_MARK}#{APOSTROPHE}]/
    EURO_SIGN = '€'.freeze
    EURO_SLUG = 'eur'.freeze

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
      name.to_s.gsub(QUOTES_TO_STRIP, '').gsub(EURO_SIGN, EURO_SLUG).parameterize
    end
  end
end
