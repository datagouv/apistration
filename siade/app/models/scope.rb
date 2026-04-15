class Scope
  def self.all
    config.values.flatten.uniq
  end

  def self.all_for_api(api)
    config.select { |controller_name, _| controller_name.to_s.include?(api) }.values.flatten.uniq
  end

  def self.config
    AppConfig.config_for(:authorizations)
  end
end
