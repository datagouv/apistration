module Datagouv
  class SyncFiche
    Result = Struct.new(:status, :uid, :remote_id, keyword_init: true)

    def initialize(endpoint, index:, client: DatagouvAPIClient.new)
      @endpoint = endpoint
      @index = index
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

    attr_reader :endpoint, :index, :client

    def skipped_result
      result(:skipped)
    end

    def deprecated_result
      remote = index.marker_match(endpoint)
      return result(:skipped_deprecated) if remote.nil?

      delete_existing(remote['id'])
      result(:deleted, remote_id: remote['id'])
    end

    def delete_existing(remote_id)
      client.delete_dataservice(remote_id)
    rescue Faraday::ResourceNotFound
      nil
    end

    def sync_current
      remote = index.find(endpoint)
      return create if remote.nil?

      sync_existing(remote)
    end

    def sync_existing(remote)
      payload = builder.payload
      return result(:unchanged, remote_id: remote['id']) if unchanged?(remote, payload)

      client.update_dataservice(remote['id'], payload)
      result(:updated, remote_id: remote['id'])
    rescue Faraday::ResourceNotFound
      create
    end

    def create
      created = client.create_dataservice(builder.creation_payload)
      result(:created, remote_id: created['id'])
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

    def result(status, remote_id: nil)
      Result.new(status: status, uid: endpoint.uid, remote_id: remote_id)
    end
  end
end
