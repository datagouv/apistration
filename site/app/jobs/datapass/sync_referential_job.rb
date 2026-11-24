module Datapass
  class SyncReferentialJob < ApplicationJob
    include GoodJob::ActiveJobExtensions::Concurrency

    queue_as :default

    good_job_control_concurrency_with(total_limit: 1, key: 'datapass_sync_referential')

    def perform
      Editor::APIS.each { |api| sync(api) }
      EditorUseCase.awaiting_datapass_completion.includes(:editor).find_each(&:complete_from_datapass_form!)
    end

    private

    def sync(api)
      DatapassReferentialSync.new(api).call
    rescue DatapassAPIClient::Error => e
      Sentry.capture_exception(e)
    end
  end
end
