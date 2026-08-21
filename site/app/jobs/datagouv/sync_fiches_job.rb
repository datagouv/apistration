module Datagouv
  class SyncFichesJob < ApplicationJob
    LOCK_NAMESPACE = 'datagouv_sync'.freeze

    retry_on StandardError, wait: :polynomially_longer, attempts: 5

    def perform
      return unless acquire_lock!

      begin
        logger.info('Start syncing fiches with data.gouv.fr')

        result = SyncRunner.new(endpoints).call

        logger.info("End syncing fiches with data.gouv.fr (#{result ? 'success' : 'with failures'})")
      ensure
        release_lock!
      end
    end

    private

    def endpoints
      APIEntreprise::Endpoint.all + APIParticulier::Endpoint.all
    end

    def logger
      @logger ||= ActiveSupport::TaggedLogging.new(Logger.new(Rails.root.join('log/datagouv.log')))
    end

    def acquire_lock!
      Rails.cache.write('datagouv_sync_in_progress', true, unless_exist: true, expires_in: 1.hour, namespace: LOCK_NAMESPACE)
    end

    def release_lock!
      Rails.cache.delete('datagouv_sync_in_progress', namespace: LOCK_NAMESPACE)
    end
  end
end
