class ApplicationMailer < ActionMailer::Base
  include ExternalUrlHelper

  helper_method :datapass_authorization_request_url, :namespace, :api_full_name

  layout 'mailer'

  helper :friendly_date
  helper :mailer_api

  default template_path: -> { _prefixes }

  before_action :extract_host

  def self.local_prefixes
    [controller_path, controller_path.sub(%r{\Aapi_(entreprise|particulier)/}, 'mailers/')].uniq
  end
  private_class_method :local_prefixes

  protected

  def api_full_name
    "API #{namespace.capitalize}"
  end

  def attach_logos_for(kind)
    attachments.inline['logo-api.png'] = Rails.root.join("app/assets/images/mailers/#{kind}/header-logo-api.png").read
    attachments.inline['logo-dinum.png'] = Rails.root.join('app/assets/images/mailers/header-logo-dinum.png').read
  end

  def valid_host(namespace)
    api = namespace.split('_').last

    case Rails.env
    when 'production'
      "#{api}.api.gouv.fr"
    when 'test', 'development'
      "#{api}.api.localtest.me:#{ENV.fetch('PORT', 3000)}"
    else
      "#{Rails.env}.#{api}.api.gouv.fr"
    end
  end
end
