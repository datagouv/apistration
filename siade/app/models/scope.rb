class Scope
  def self.all
    Rails.application.config_for(:authorizations).values.flatten.uniq
  end
end
