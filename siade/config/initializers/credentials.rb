module Siade
  def self.credentials
    @credentials ||= begin
      credentials = Rails.application.credentials.config[Rails.env.to_sym] || {}

      unless ENV['ZEITWERK_CHECK']
        if Rails.env.local?
          credentials.default_proc = proc do |hash, key|
            is_url_or_domain = key.to_s.include?('_url') || key.to_s.end_with?('_domain')

            hash[key] = is_url_or_domain ? "https://#{key}.gouv.fr" : key.to_s
          end
        else
          credentials.default_proc = proc do |_, key|
            raise KeyError, "key '#{key}' not found"
          end
        end
      end

      credentials
    end
  end
end
