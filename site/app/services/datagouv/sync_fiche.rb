module Datagouv
  class SyncFiche
    Result = Struct.new(:status, :uid, :datagouv_uid, keyword_init: true)

    def initialize(endpoint, client: DatagouvAPIClient.new)
      @endpoint = endpoint
      @client = client
    end

    def call
      return skipped_result unless endpoint.sync_with_datagouv?
      return deprecated_result if endpoint.deprecated?

      sync_current
    rescue Faraday::Error => e
      failed_result(e)
    end

    private

    attr_reader :endpoint, :client

    def skipped_result
      result(:skipped)
    end

    def deprecated_result
      return result(:skipped_deprecated, datagouv_uid: nil) if endpoint.datagouv_uid.blank?

      delete_existing
      result(:deleted, datagouv_uid: nil)
    end

    def delete_existing
      client.delete_dataservice(endpoint.datagouv_uid)
    rescue Faraday::ResourceNotFound
      nil
    end

    def sync_current
      return create if endpoint.datagouv_uid.blank?

      sync_existing
    end

    def sync_existing
      remote = client.find_dataservice(endpoint.datagouv_uid)
      payload = builder.payload

      return result(:unchanged) if unchanged?(remote, payload)

      client.update_dataservice(endpoint.datagouv_uid, payload)
      result(:updated)
    rescue Faraday::ResourceNotFound
      create
    end

    def create
      created = client.create_dataservice(builder.creation_payload)
      result(:created, datagouv_uid: created['id'])
    end

    def unchanged?(remote, payload)
      payload.all? { |key, value| remote[key.to_s] == value }
    end

    def builder
      @builder ||= FichePayloadBuilder.new(endpoint)
    end

    def failed_result(error)
      Rails.logger.error("Datagouv::SyncFiche: #{endpoint.uid} failed - #{error.message}")
      result(:failed)
    end

    def result(status, datagouv_uid: endpoint.datagouv_uid)
      Result.new(status: status, uid: endpoint.uid, datagouv_uid: datagouv_uid)
    end
  end
end
