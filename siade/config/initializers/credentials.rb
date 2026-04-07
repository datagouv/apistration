module Siade
  def self.credentials
    @credentials ||= begin
      env_file = Rails.root.join('config', 'credentials', "#{Rails.env}.yml")
      base_file = Rails.root.join('config', 'credentials.yml')

      credentials = if env_file.exist?
        YAML.safe_load_file(env_file, symbolize_names: true, aliases: true) || {}
      elsif base_file.exist?
        YAML.safe_load_file(base_file, symbolize_names: true, aliases: true)[Rails.env.to_sym] || {}
      else
        {}
      end

      unless ENV['ZEITWERK_CHECK']
        if Rails.env.local? || Rails.env.staging?
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
