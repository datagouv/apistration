module Siade
  def self.credentials
    @credentials ||= begin
      credentials = Rails.application.credentials.config[Rails.env.to_sym] || {}

      credentials.default_proc = proc do |_,key|
        raise KeyError, "key '#{key}' not found"
      end

      credentials
    end
  end
end
