class EditorAPIDomainConstraint
  HOST_PATTERN = /\A(entreprise|particulier)\.api(\.|\z)/

  def self.api_for_host(host)
    match = HOST_PATTERN.match(host)
    match && match[1]
  end

  def matches?(request)
    HOST_PATTERN.match?(request.host)
  end
end
