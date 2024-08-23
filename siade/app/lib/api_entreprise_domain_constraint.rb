class APIEntrepriseDomainConstraint < APIDomainConstraint
  protected

  def host_matches?(request)
    !!(request.host =~ /entreprise\.api/)
  end
end
