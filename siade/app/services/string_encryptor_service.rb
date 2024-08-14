class StringEncryptorService
  include Singleton

  def encrypt_url_safe(string)
    Base64.urlsafe_encode64(encrypt(string))
  end

  def decrypt_url_safe(string)
    unescaped_string = Base64.urlsafe_decode64(string)

    decrypt(unescaped_string)
  end

  def encrypt(string)
    encryptor.encrypt_and_sign(string)
  end

  def decrypt(string)
    encryptor.decrypt_and_verify(string)
  end

  private

  def encryptor
    ActiveSupport::MessageEncryptor.new(key)
  end

  def key
    ActiveSupport::KeyGenerator.new(password).generate_key(salt, 32)
  end

  def salt
    Siade.credentials[:string_encryptor_service_salt]
  end

  def password
    Siade.credentials[:string_encryptor_service_password]
  end
end
