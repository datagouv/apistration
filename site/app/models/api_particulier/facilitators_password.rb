class APIParticulier::FacilitatorsPassword
  def self.value
    AdminApientreprise.credentials[:api_particulier_facilitators_password]
  end

  def self.matches?(candidate)
    value.present? && ActiveSupport::SecurityUtils.secure_compare(candidate.to_s, value)
  end

  def self.fingerprint
    OpenSSL::HMAC.hexdigest('SHA256', Rails.application.secret_key_base, value)
  end

  def self.fingerprint_matches?(candidate)
    value.present? && ActiveSupport::SecurityUtils.secure_compare(candidate.to_s, fingerprint)
  end
end
