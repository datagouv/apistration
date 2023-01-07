class ScopesAuthorizationService
  attr_reader :controller_name, :user_scopes

  def initialize(user_scopes, controller_name)
    @user_scopes = user_scopes
    @controller_name = controller_name
  end

  def allow?
    scopes.empty? ||
      scopes.intersect?(user_scopes)
  end

  private

  def scopes
    @scopes ||= config[controller_name_sanitizied] || (raise "No authorization config for controller #{controller_name}\nPlease fill the config/authorizations.yml file for '#{controller_name_sanitizied}'")
  end

  def controller_name_sanitizied
    controller_name.underscore.sub('_controller', '')
  end

  def config
    Rails.application.config_for(:authorizations)
  end
end
