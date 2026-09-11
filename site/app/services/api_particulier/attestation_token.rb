class APIParticulier::AttestationToken
  VERIFICATION_PURPOSE = :attestation_verification

  class << self
    def read_verification(token)
      decrypted = encryptor.decrypt_and_verify(token, purpose: VERIFICATION_PURPOSE)

      raise ActiveSupport::MessageEncryptor::InvalidMessage if decrypted.nil?

      JSON.parse(Zlib::Inflate.inflate(decrypted))
    rescue ArgumentError, JSON::ParserError, Zlib::Error
      raise ActiveSupport::MessageEncryptor::InvalidMessage
    end

    def visual_code(token)
      Digest::SHA256.hexdigest(token)[0, 10].upcase.insert(4, '-').insert(9, '-')
    end

    private

    def encryptor
      @encryptor ||= ActiveSupport::MessageEncryptor.new(key, url_safe: true,
        serializer: ActiveSupport::MessageEncryptor::NullSerializer)
    end

    def key
      ActiveSupport::KeyGenerator.new(credential(:attestation_encryptor_password))
        .generate_key(credential(:attestation_encryptor_salt), 32)
    end

    def credential(name) = AdminApientreprise.credentials[name]
  end
end
