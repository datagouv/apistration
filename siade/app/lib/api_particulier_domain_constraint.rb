class APIParticulierDomainConstraint
  attr_reader :v3_and_more

  def initialize(v3_and_more: false)
    @v3_and_more = v3_and_more
  end

  def matches?(request)
    !!(request.host =~ /particulier\.api/) && api_version_valid?(request)
  end

  private

  def api_version_valid?(request)
    !v3_and_more ||
      !!(request.path_parameters[:api_version] =~ /\d+/)
  end
end
