return unless Rails.env.production?

require 'sync_pings_with_monitors_remote_service'

SyncPingsWithMonitorsRemoteService.new.perform
