class APIParticulierV2DomainConstraint
  def matches?(request)
    request.host =~ /particulier\.api/
  end
end
