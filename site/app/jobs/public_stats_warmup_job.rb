class PublicStatsWarmupJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  CONCURRENCY_KEY = 'public_stats_warmup'.freeze

  queue_as :default

  good_job_control_concurrency_with(total_limit: 1, key: CONCURRENCY_KEY)

  def perform
    PublicStatsQuery::APIS.product(PublicStatsQuery::PERIODS).each do |api, period|
      PublicStatsQuery.new(api, period).compute
    end
  end
end
