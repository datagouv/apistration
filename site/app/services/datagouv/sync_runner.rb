module Datagouv
  class SyncRunner
    def initialize(endpoints)
      @endpoints = endpoints
    end

    def call
      results = endpoints.map { |endpoint| sync_one(endpoint) }
      results.none? { |result| result.status == :failed }
    end

    private

    attr_reader :endpoints

    def sync_one(endpoint)
      result = SyncFiche.new(endpoint).call
      Rails.logger.info("Datagouv::SyncRunner: #{result.uid} -> #{result.status}")
      perform_write_back(endpoint, result)
    end

    def perform_write_back(endpoint, result)
      write_yml(endpoint, result)
      result
    rescue StandardError => e
      Rails.logger.error(
        "Datagouv::SyncRunner: #{endpoint.uid} write-back failed - #{e.message} " \
        "(orphaned datagouv_uid, needs manual reconciliation: #{result.datagouv_uid.inspect})"
      )
      SyncFiche::Result.new(status: :failed, uid: result.uid, datagouv_uid: result.datagouv_uid)
    end

    def write_yml(endpoint, result)
      case result.status
      when :created
        YmlUidWriter.new(api: endpoint.api, uid: endpoint.uid).write(result.datagouv_uid)
      when :deleted
        YmlUidWriter.new(api: endpoint.api, uid: endpoint.uid).remove
      end
    end
  end
end
