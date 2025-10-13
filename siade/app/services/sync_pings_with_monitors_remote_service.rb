class SyncPingsWithMonitorsRemoteService
  def perform
    return if in_progress?

    mark_as_in_progress!

    logger.info('Start syncing pings with monitors')

    pings.each do |api_kind, config|
      config.each do |ping_identifier, ping_config|
        next if ping_config[:status_page].blank?

        create_or_update_monitor(api_kind, ping_identifier, ping_config)
      end
    end

    clear_in_progress!

    logger.info('End syncing pings with monitors')
  end

  private

  def create_or_update_monitor(api_kind, ping_identifier, ping_config)
    if (remote_monitor = find_remote_monitor(api_kind, ping_identifier))
      update_monitor(ping_config, remote_monitor)
    else
      create_monitor(api_kind, ping_identifier, ping_config)
    end
  rescue HyperpingAPI::Error, StandardError => e
    logger.error("Error while syncing #{api_kind} #{ping_identifier}: #{e.message}")
  end

  def create_monitor(api_kind, ping_identifier, ping_config)
    hyperping_api_service.create_monitor(
      default_params.merge(
        url: url_for(api_kind, ping_identifier)
      ).merge(
        extract_ping_config(ping_config)
      )
    )
  end

  def update_monitor(ping_config, remote_monitor)
    hyperping_api_service.update_monitor(
      remote_monitor['uuid'],
      default_params.merge(
        extract_ping_config(ping_config)
      )
    )
  end

  def url_for(api_kind, identifier)
    case api_kind
    when :api_entreprise
      "https://entreprise.api.gouv.fr/ping/#{identifier}"
    else
      "https://particulier.api.gouv.fr/api/#{identifier}/ping"
    end
  end

  def default_params
    {
      regions: %w[
        london
        paris
        frankfurt
        amsterdam
      ],
      alerts_wait: 1,
      paused: false
    }
  end

  def extract_ping_config(ping_config)
    %i[
      name
      alerts_wait
      paused
    ].each_with_object({}) do |key, hash|
      hash[key] = ping_config[:status_page][key] if ping_config[:status_page][key].present?
    end
  end

  def find_remote_monitor(api_kind, ping_identifier)
    remote_monitors.find do |remote_monitor|
      remote_monitor['url'] == url_for(api_kind, ping_identifier)
    end
  end

  def hyperping_api_service
    @hyperping_api_service ||= HyperpingAPI.new
  end

  def remote_monitors
    @remote_monitors ||= hyperping_api_service.get_monitors
  end

  def logger
    @logger ||= ActiveSupport::TaggedLogging.new(Logger.new(Rails.root.join('log/hyperping.log')))
  end

  def in_progress?
    Rails.cache.read('sync_pings_with_monitors_in_progress').present?
  end

  def mark_as_in_progress!
    Rails.cache.write('sync_pings_with_monitors_in_progress', true, expires_in: 1.hour)
  end

  def clear_in_progress!
    Rails.cache.delete('sync_pings_with_monitors_in_progress')
  end

  def pings
    Rails.application.config_for(:pings)
  end
end
