module Siade
  def self.credentials
    Rails.application.credentials.config[Rails.env.to_sym]
  end
end
