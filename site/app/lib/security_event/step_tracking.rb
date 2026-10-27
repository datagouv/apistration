module SecurityEvent::StepTracking
  extend ActiveSupport::Concern

  class_methods do
    def tracks_with(*trackers)
      around do |interactor|
        interactor.call
      ensure
        trackers.each { |tracker| tracker.call(context.to_h) }
      end
    end
  end
end
