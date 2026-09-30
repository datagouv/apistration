module PersonalDataAnonymizer
  EMAIL_DOMAIN = 'yopmail.com'.freeze
  EMAIL_PREFIX = 'anon-'.freeze
  EMAIL_DIGEST_LENGTH = 12
  NAME_DIGEST_LENGTH = 6
  PHONE = '0100000000'.freeze

  class << self
    def email(value)
      return value if value.blank?

      normalized_email = value.downcase.strip
      return value unless normalized_email.match?(URI::MailTo::EMAIL_REGEXP)
      return normalized_email if normalized_email.end_with?("@#{EMAIL_DOMAIN}")

      "#{EMAIL_PREFIX}#{digest(normalized_email, EMAIL_DIGEST_LENGTH)}@#{EMAIL_DOMAIN}"
    end

    def first_name(value)
      name('Prénom', value)
    end

    def last_name(value)
      name('Nom', value)
    end

    def phone(value)
      return value if value.blank?

      PHONE
    end

    private

    def name(label, value)
      return value if value.blank?
      return value if value.match?(/\A#{label} \h{#{NAME_DIGEST_LENGTH}}\z/)

      "#{label} #{digest(value, NAME_DIGEST_LENGTH)}"
    end

    def digest(value, length)
      OpenSSL::HMAC.hexdigest('SHA256', Rails.application.secret_key_base, value).first(length)
    end
  end
end
