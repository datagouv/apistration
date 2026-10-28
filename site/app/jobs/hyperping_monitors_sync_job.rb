class HyperpingMonitorsSyncJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  class SyncError < StandardError; end

  good_job_concurrency_rule(label: 'hyperping_monitors_sync', apply_label: true, total_limit: 1)

  DEFAULT_PARAMS = {
    regions: %w[
      london
      paris
      frankfurt
      amsterdam
    ],
    alerts_wait: 1,
    paused: false
  }.freeze

  MONITOR_KEYS = %i[name alerts_wait paused].freeze

  API_KINDS = %i[api_entreprise api_particulier].freeze

  def perform
    return unless frontal_production?

    hyperping_logger.info('Start syncing pings with monitors')

    remote_monitors = hyperping_api.get_monitors
    failures = sync_monitors(remote_monitors)

    hyperping_logger.info('End syncing pings with monitors')

    raise SyncError, "#{failures.size} monitors failed to sync: #{failures.join('; ')}" if failures.any?
  end

  private

  def sync_monitors(remote_monitors)
    pings.flat_map do |api_kind, api_pings|
      api_pings.filter_map do |identifier, ping|
        next if ping[:status_page].blank?

        sync_monitor(remote_monitors, api_kind, identifier.to_s, ping[:status_page])
      end
    end
  end

  def sync_monitor(remote_monitors, api_kind, identifier, status_page)
    url = url_for(api_kind, identifier)
    params = DEFAULT_PARAMS.merge(status_page.slice(*MONITOR_KEYS).compact_blank)

    if (remote_monitor = remote_monitors.find { |monitor| monitor['url'] == url })
      update_monitor(remote_monitor, params)
    else
      create_monitor(api_kind, identifier, params.merge(url:))
    end

    nil
  rescue StandardError => e
    hyperping_logger.error("Error while syncing #{api_kind} #{identifier}: #{e.message}")
    "#{api_kind} #{identifier}: #{e.message}"
  end

  def update_monitor(remote_monitor, params)
    hyperping_api.update_monitor(remote_monitor['uuid'], params)
    hyperping_logger.info("Monitor updated: #{remote_monitor['name']} (#{remote_monitor['uuid']})")
  end

  def create_monitor(api_kind, identifier, params)
    hyperping_api.create_monitor(params)
    hyperping_logger.info("Monitor created for #{api_kind} #{identifier}")
  end

  def url_for(api_kind, identifier)
    if api_kind == :api_entreprise
      "https://entreprise.api.gouv.fr/ping/#{identifier}"
    else
      "https://particulier.api.gouv.fr/api/#{identifier}/ping"
    end
  end

  def pings
    Rails.application.config_for(:pings).slice(*API_KINDS)
  end

  def hyperping_api
    @hyperping_api ||= HyperpingAPI.new
  end

  def hyperping_logger
    @hyperping_logger ||= Logger.new(Rails.root.join('log/hyperping.log'))
  end
end
