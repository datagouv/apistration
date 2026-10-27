module Simplifions
  module Connection
    USER_AGENT = 'APIEntreprise-site/1.0'.freeze

    def self.build
      Faraday.new(headers: { 'User-Agent' => USER_AGENT }) do |f|
        f.response :raise_error
        f.adapter :net_http
        f.options.open_timeout = 2
        f.options.timeout = 5
      end
    end
  end
end
