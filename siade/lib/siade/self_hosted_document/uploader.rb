require 'securerandom'
require 'fog/openstack'

class SIADE::SelfHostedDocument::Uploader
  attr_reader :filename

  class HostingServiceException < StandardError; end

  class << self
    def storage_shared_connexion
      # Fog credentials are set in an initializer
      @storage_shared_connexion ||= Fog::OpenStack::Storage.new(Fog.credentials)
    end

    def call(filename, content)
      uploader = new(filename)
      uploader.store!(content)
      uploader
    rescue *uploader_hosting_errors
      raise HostingServiceException
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

  def initialize(filename)
    @filename = filename
  end

  def store!(pdf_string)
    storage.put_object(
      container_name,
      file_url,
      pdf_string,
      {
        'X-Delete-After' => file_expired_in
      }
    )
  end

  def file_expired_in
    3.months.to_i
  end

  def url
    customized_domain_url
  end

  private

  def customized_domain_url
    storage_domain_url.sub(%r{https.*/AUTH_[[:alnum:]]*/}, Siade.credentials[:public_storage_url])
  end

  def storage_domain_url
    @storage_domain_url ||= storage.public_url(container_name, file_url)
  end

  def container_name
    if Rails.env.production?
      'siade'
    else
      'siade_dev'
    end
  end

  def file_url
    @file_url ||= [timestamp_string, secure_token, filename].compact.join('-')
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
