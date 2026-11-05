class EmailDomain
  WEBMAIL_DOMAINS = YAML.load_file(Rails.root.join('config/webmail_domains.yml')).to_set.freeze

  attr_reader :name

  def initialize(email)
    @name = email.to_s.split('@').last.to_s.downcase.strip
  end

  def webmail?
    WEBMAIL_DOMAINS.include?(name)
  end

  def outside?(emails)
    emails.map { |email| self.class.new(email).name }.exclude?(name)
  end
end
