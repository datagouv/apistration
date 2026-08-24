module Datagouv
  class SyncFiche
    Result = Struct.new(:status, :uid, :remote_id, keyword_init: true)

    def initialize(endpoint, index:, client: DatagouvAPIClient.new, logger: Rails.logger)
      @endpoint = endpoint
      @index = index
      @client = client
      @logger = logger
    end

    def call
      return skipped_result unless endpoint.sync_with_datagouv?
      return deprecated_result if endpoint.deprecated?

      sync_current
    rescue Faraday::Error => e
      failed_result(e)
    end

    private

    attr_reader :endpoint, :index, :client, :logger

    def skipped_result
      result(:skipped)
    end

    def deprecated_result
      remote = index.find(endpoint)
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

      updated = client.update_dataservice(remote['id'], payload)
      return unexpected_response_result('update did not take effect') unless unchanged?(updated, payload)

      result(:updated, remote_id: remote['id'])
    rescue Faraday::ResourceNotFound
      create
    end

    def create
      created = client.create_dataservice(builder.creation_payload)
      return unexpected_response_result('create returned no id') if created['id'].blank?

      result(:created, remote_id: created['id'])
    end

    def unchanged?(remote, payload)
      payload.all? { |key, value| remote[key.to_s] == value }
    end

    def builder
      @builder ||= FichePayloadBuilder.new(endpoint)
    end

    def failed_result(error)
      body = error.respond_to?(:response) ? error.response&.dig(:body) : nil
      logger.error("SyncFiche: #{endpoint.uid} failed - #{error.class}: #{error.message}#{" - #{body}" if body.present?}")
      result(:failed)
    end

    def unexpected_response_result(message)
      logger.error("SyncFiche: #{endpoint.uid} failed - #{message}")
      result(:failed)
    end

    def result(status, remote_id: nil)
      Result.new(status: status, uid: endpoint.uid, remote_id: remote_id)
    end
  end
end
