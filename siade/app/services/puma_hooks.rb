class PumaHooks
  def on_booted
    return unless Rails.env.production?

    SyncPingsWithMonitorsRemoteService.new.perform
  end
end
