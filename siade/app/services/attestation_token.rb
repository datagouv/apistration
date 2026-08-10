class AttestationToken
  class Expired < StandardError
  end

  VERIFICATION_PURPOSE = :attestation_verification
  PDF_PURPOSE = :attestation_pdf

  class << self
    def generate(payload, purpose:, expires_in: nil, expires_at: nil)
      payload = payload.merge('exp' => expires_at) if expires_at

      encryptor.encrypt_and_sign(Zlib::Deflate.deflate(payload.to_json), purpose:, expires_in:)
    end

    def read(token, purpose:)
      payload = decrypt(token, purpose:)

      raise Expired if payload['exp'] && Time.zone.at(payload['exp']).past?

      payload.except('exp')
    end

    def visual_code(token)
      Digest::SHA256.hexdigest(token)[0, 10].upcase.insert(4, '-').insert(9, '-')
    end

    def verification_url(token)
      "#{base_url}/attestations/verification/#{token}"
    end

    def base_url
      host = Rails.env.production? ? 'particulier.api.gouv.fr' : "#{Rails.env}.particulier.api.gouv.fr"

      "https://#{host}"
    end

    private

    def decrypt(token, purpose:)
      decrypted = encryptor.decrypt_and_verify(token, purpose:)

      raise ActiveSupport::MessageEncryptor::InvalidMessage if decrypted.nil?

      JSON.parse(Zlib::Inflate.inflate(decrypted))
    rescue ArgumentError, JSON::ParserError, Zlib::Error
      raise ActiveSupport::MessageEncryptor::InvalidMessage
    end

    def encryptor
      @encryptor ||= ActiveSupport::MessageEncryptor.new(key, url_safe: true,
        serializer: ActiveSupport::MessageEncryptor::NullSerializer)
    end

    def key
      ActiveSupport::KeyGenerator.new(Siade.credentials[:attestation_encryptor_password])
        .generate_key(Siade.credentials[:attestation_encryptor_salt], 32)
    end
  end
end
