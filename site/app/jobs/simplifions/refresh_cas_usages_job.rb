module Simplifions
  class RefreshCasUsagesJob < ApplicationJob
    include GoodJob::ActiveJobExtensions::Concurrency

    CONCURRENCY_KEY = 'simplifions_refresh_cas_usages'.freeze
    EXPIRES_IN = 7.days

    queue_as :default

    good_job_control_concurrency_with(total_limit: 1, key: CONCURRENCY_KEY)

    def perform
      Rails.cache.write(
        SimplifionsStore::CACHE_KEY,
        CasUsagesCatalog.build,
        namespace: SimplifionsStore::CACHE_NAMESPACE,
        expires_in: EXPIRES_IN
      )
    end
  end
end
