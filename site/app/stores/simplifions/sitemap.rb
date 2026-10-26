module Simplifions
  class Sitemap
    class NoCasUsageError < StandardError; end

    SITEMAP_URL = 'https://simplifions.data.gouv.fr/sitemap.xml'.freeze

    LEFT_SINGLE_QUOTATION_MARK = '‘'.freeze
    RIGHT_SINGLE_QUOTATION_MARK = '’'.freeze
    APOSTROPHE = "'".freeze
    QUOTES_TO_STRIP = /[#{LEFT_SINGLE_QUOTATION_MARK}#{RIGHT_SINGLE_QUOTATION_MARK}#{APOSTROPHE}]/
    EURO_SIGN = '€'.freeze
    EURO_SLUG = 'eur'.freeze

    def self.fetch
      document = Nokogiri::XML(Connection.build.get(SITEMAP_URL).body, &:strict)
      document.remove_namespaces!

      slugs = document.xpath('//url/loc').filter_map { |loc|
        loc.text[%r{/demarches/([^/?#]+)}, 1]
      }.uniq.sort
      raise NoCasUsageError, "no cas usage in #{SITEMAP_URL}" if slugs.empty?

      new(slugs)
    end

    def initialize(slugs)
      @slugs = slugs
    end

    def slug_for(name)
      base_slug = slugify(name)
      return base_slug if @slugs.include?(base_slug)

      suffixed_slugs = @slugs.grep(/\A#{Regexp.escape(base_slug)}-\d+\z/)
      return suffixed_slugs.first if suffixed_slugs.one?

      Rails.logger.warn("Simplifions::Sitemap: ambiguous slug for #{name}") if suffixed_slugs.many?
      base_slug
    end

    private

    def slugify(name)
      name.to_s.gsub(QUOTES_TO_STRIP, '').gsub(EURO_SIGN, EURO_SLUG).parameterize
    end
  end
end
