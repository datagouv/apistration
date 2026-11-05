module BackOfficeAuthorizationRequests
  CONFIG_PATH = Rails.root.join('config/back_office_authorization_requests.yml')

  def self.datapass_ids
    @datapass_ids ||= YAML.load_file(CONFIG_PATH).values.map(&:to_s).freeze
  end

  def self.include?(datapass_id)
    datapass_id.present? && datapass_ids.include?(datapass_id.to_s)
  end
end
