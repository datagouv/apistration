module HostMethodsHelpers
  def current_host
    "#{Rails.env}.entreprise.api.gouv.fr"
  end

  def current_host_url
    "https://#{current_host}"
  end
end
