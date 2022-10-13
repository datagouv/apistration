module Siade
  def self.credentials
    @credentials ||= begin
      credentials = Rails.application.credentials.config[Rails.env.to_sym] || {}

      unless ENV['ZEITWERK_CHECK']
        credentials.default_proc = proc do |_,key|
          raise KeyError, "key '#{key}' not found"
        end
      end

      credentials
    end
  end
end
