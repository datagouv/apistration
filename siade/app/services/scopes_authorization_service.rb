class ScopesAuthorizationService
  attr_reader :resource_name, :user_scopes

  class ResourceNameInvalidError < StandardError; end

  def initialize(user_scopes, resource_name)
    @user_scopes = user_scopes
    @resource_name = resource_name
  end

  def allow?
    scopes.empty? ||
      scopes.intersect?(user_scopes)
  end

  private

  def scopes
    @scopes ||= config[resource_name_sanitized] || raise_no_authorization
  end

  def raise_no_authorization
    raise "No authorization config for resource #{resource_name}\nPlease fill the config/authorizations.yml file for '#{resource_name_sanitized}'"
  end

  def resource_name_sanitized
    if resource_name.end_with?('Controller')
      resource_name.underscore.sub('_controller', '')
    elsif resource_name.start_with?('mcp/')
      resource_name
    else
      raise ResourceNameInvalidError, "Resource name '#{resource_name}' is not valid. It should end with 'Controller' or start with 'mcp/'"
    end
  end

  def config
    Rails.application.config_for(:authorizations)
  end
end
