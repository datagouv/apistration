module Datagouv
  class SyncFichesRemoteService
    def perform
      return unless acquire_lock!

      logger.info('Start syncing fiches with data.gouv.fr')

      result = SyncRunner.new(endpoints).call

      logger.info("End syncing fiches with data.gouv.fr (#{result ? 'success' : 'with failures'})")

      release_lock!
    end

    private

    def endpoints
      APIEntreprise::Endpoint.all + APIParticulier::Endpoint.all
    end

    def logger
      @logger ||= ActiveSupport::TaggedLogging.new(Logger.new(Rails.root.join('log/datagouv.log')))
    end

    def acquire_lock!
      Rails.cache.write('datagouv_sync_in_progress', true, unless_exist: true, expires_in: 1.hour)
    end

    def release_lock!
      Rails.cache.delete('datagouv_sync_in_progress')
    end
  end
end
