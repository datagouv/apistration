module SiteHost
  def self.for(namespace)
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
