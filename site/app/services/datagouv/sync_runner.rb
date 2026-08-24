module Datagouv
  class SyncRunner
    def initialize(endpoints, logger: Rails.logger)
      @endpoints = endpoints
      @logger = logger
    end

    def call
      index = build_index
      return false if index.nil?

      results = endpoints.map { |endpoint| sync_one(endpoint, index) }
      logger.info("SyncRunner: #{summary(results)}")
      results.none? { |result| result.status == :failed }
    end

    private

    attr_reader :endpoints, :logger

    def build_index
      index = DataserviceIndex.new
      logger.info("SyncRunner: matched against #{index.size} existing remote dataservices")
      index
    rescue Faraday::Error => e
      logger.error("SyncRunner: failed to list dataservices - #{e.message}")
      nil
    end

    def summary(results)
      counts = results.group_by(&:status).transform_values(&:size)
      "#{results.size} endpoints processed - #{counts.map { |status, count| "#{status}: #{count}" }.join(', ')}"
    end

    def sync_one(endpoint, index)
      result = SyncFiche.new(endpoint, index: index, logger: logger).call
      logger.info(log_message(result))
      result
    end

    def log_message(result)
      suffix = result.remote_id ? " (#{result.remote_id})" : ''
      "SyncRunner: #{result.uid} -> #{result.status}#{suffix}"
    end
  end
end
