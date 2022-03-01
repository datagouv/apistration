class Documents::Upload < ApplicationInteractor
  EXPIRES_IN = 1.day.to_i

  before do
    context.errors ||= []
  end

  class << self
    def storage_shared_connexion
      # Fog credentials are set in an initializer
      @storage_shared_connexion ||= Fog::OpenStack::Storage.new(Fog.credentials)
    end
  end

  def call
    store!
    context.url = document_public_url
  rescue *uploader_hosting_errors
    context.errors << HostingServiceError.new
    context.fail!
  end

  def store!
    storage.put_object(
      container_name,
      document_path,
      file_content,
      {
        'X-Delete-After' => file_expired_in
      }
    )
  end

  def file_content
    context.content
  end

  def filename
    "#{context.filename}.#{context.file_type}"
  end

  def document_public_url
    document_url.sub(
      %r{https.*/AUTH_[[:alnum:]]*/},
      public_storage_url
    )
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

  def file_expired_in
    EXPIRES_IN
  end

  def public_storage_url
    Siade.credentials[:public_storage_url]
  end

  def storage
    self.class.storage_shared_connexion
  end

  def uploader_hosting_errors
    [
      Excon::Error::InternalServerError,
      Excon::Error::Socket,
      Excon::Error::ServiceUnavailable,
      Excon::Error::Timeout
    ]
  end
end
