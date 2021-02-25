class Documents::Upload < ApplicationInteractor
  class << self
    def storage_shared_connexion
      # Fog credentials are set in an initializer
      @storage_shared_connexion ||= Fog::OpenStack::Storage.new(Fog.credentials)
    end
  end

  def call
    store!
    context.url = document_public_url
  end

  def store!
    storage.put_object(container_name, document_path, file_content)
  end

  def file_content
    context.content
  end

  def filename
    context.filename
  end

  def document_public_url
    document_url.sub(%r{https.*/AUTH_[[:alnum:]]*\/},PUBLIC_STORAGE_URL)
  end

  def document_url
    @document_url ||= storage.public_url(container_name, document_path)
  end

  def container_name
    Rails.env.production? ? 'siade' : 'siade_dev'
  end

  def document_path
    @document_path ||= [timestamp_string, secure_token, filename].compact.join('-')
  end

  def timestamp_string
    @timestamp_string ||= Time.now.to_i.to_s
  end

  def secure_token
    @secure_token ||= SecureRandom.hex(20)
  end

  def storage
    self.class.storage_shared_connexion
  end
end
