module Datagouv
  class SyncRunner
    def initialize(endpoints)
      @endpoints = endpoints
    end

    def call
      index = build_index
      return false if index.nil?

      results = endpoints.map { |endpoint| sync_one(endpoint, index) }
      results.none? { |result| result.status == :failed }
    end

    private

    attr_reader :endpoints

    def build_index
      DataserviceIndex.new
    rescue Faraday::Error => e
      Rails.logger.error("Datagouv::SyncRunner: failed to list dataservices - #{e.message}")
      nil
    end

    def sync_one(endpoint, index)
      result = SyncFiche.new(endpoint, index: index).call
      Rails.logger.info(log_message(result))
      result
    end

    def log_message(result)
      suffix = result.remote_id ? " (#{result.remote_id})" : ''
      "Datagouv::SyncRunner: #{result.uid} -> #{result.status}#{suffix}"
    end
  end
end
