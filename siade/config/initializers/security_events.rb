Rails.application.config.after_initialize do
  Rails.event.subscribe(SecurityEvent::LogSubscriber.new) do |event|
    event[:name] == SecurityEvent::NOTIFICATION_NAME
  end

  ActiveSupport::Notifications.subscribe('start_processing.action_controller') do
    SecurityEvent::LogSubscriber.open_request_line
  end

  ActiveSupport::Notifications.subscribe('process_action.action_controller') do
    SecurityEvent::LogSubscriber.close_request_line
  end
end
