class ExtraitCourtINPIPolicy < APIPolicy
  def jwt_role_tag
    'extrait_court_inpi'
  end
end
