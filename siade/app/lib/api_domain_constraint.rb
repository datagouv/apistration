class APIDomainConstraint
  attr_reader :v3_and_more

  def initialize(v3_and_more: false)
    @v3_and_more = v3_and_more
  end

  def matches?(request)
    host_matches?(request) && api_version_valid?(request)
  end

  protected

  def host_matches?(request)
    !!(request.host =~ /entreprise\.api/)
  end

  private

  def api_version_valid?(request)
    !v3_and_more ||
      !!(request.path_parameters[:api_version] =~ /\d+/)
  end
end
