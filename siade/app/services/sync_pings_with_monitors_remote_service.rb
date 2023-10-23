require 'hyperping_api'
require 'monitoring_service'

class SyncPingsWithMonitorsRemoteService
  def perform
    pings.each do |api_kind, config|
      config.each do |ping_identifier, ping_config|
        next if ping_config[:status_page].blank?

        create_or_update_monitor(api_kind, ping_identifier, ping_config)
      end
    end
  end

  private

  def create_or_update_monitor(api_kind, ping_identifier, ping_config)
    if (remote_monitor = find_remote_monitor(api_kind, ping_identifier))
      update_monitor(ping_config, remote_monitor)
    else
      create_monitor(api_kind, ping_identifier, ping_config)
    end
  rescue StandardError => e
    MonitoringService.instance.track(
      'warning',
      'Fail to update ping properties on status page',
      {
        identifier: ping_identifier,
        error: e.message,
        backtrace: e.backtrace
      }
    )
  end

  def create_monitor(api_kind, ping_identifier, ping_config)
    hyperping_api_service.create_monitor(
      default_params.merge(
        name: ping_config[:status_page][:name],
        url: url_for(api_kind, ping_identifier)
      )
    )
  end

  def update_monitor(ping_config, remote_monitor)
    hyperping_api_service.update_monitor(
      remote_monitor['uuid'],
      default_params.merge(
        name: ping_config[:status_page][:name]
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
      ]
    }
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

  def pings
    Rails.application.config_for(:pings)
  end
end
