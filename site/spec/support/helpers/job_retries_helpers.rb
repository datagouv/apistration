module JobRetriesHelpers
  def perform_with_retries(job_class, ...)
    adapter = job_class.queue_adapter
    previous_flags = [adapter.perform_enqueued_jobs, adapter.perform_enqueued_at_jobs]
    adapter.perform_enqueued_jobs = true
    adapter.perform_enqueued_at_jobs = true

    job_class.perform_later(...)
  ensure
    adapter.perform_enqueued_jobs, adapter.perform_enqueued_at_jobs = previous_flags
  end
end
