class APIParticulierDomainConstraint < APIDomainConstraint
  protected

  def host_matches?(request)
    !!(request.host =~ /particulier\.api/)
  end
end
