class DataEncryptor
  def initialize(data)
    @data = data
  end

  def encrypt
    crypto.encrypt(GPGME::Data.new(@data), encrypt_options)
  end

  def decrypt
    crypto.decrypt(GPGME::Data.new(@data), pinentry_mode: GPGME::PINENTRY_MODE_LOOPBACK, passphrase_callback: method(:passphrase_callback))
  end

  private

  def crypto
    @crypto ||= GPGME::Crypto.new
  end

  def encrypt_options
    {
      recipients: public_key_ids,
      signers: signer_info[:signer_email],
      pinentry_mode: GPGME::PINENTRY_MODE_LOOPBACK,
      always_trust: true,
      sign: true,
      armor: true,
      passphrase_callback: method(:passphrase_callback)
    }
  end

  def passphrase_callback(_hook, _uid_hint, _passphrase_info, _prev_was_bad, file_descriptor)
    io = IO.for_fd(file_descriptor, 'w')
    io.puts(signer_info[:signer_passphrase])
    io.flush
  end

  def public_key_ids
    Dir['config/gpg_public_keys_for_data_encryption/*.asc'].map do |key|
      GPGME::Key.import(File.open(key)).imports.first.fpr
    end
  end

  def signer_info
    Rails.application.config_for(:encrypt_data_signer_data)
  end
end
