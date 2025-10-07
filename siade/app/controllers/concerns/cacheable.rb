module Cacheable
  extend ActiveSupport::Concern

  included do
    attr_reader :cached_retriever

    before_action :init_x_response_cached_header
    after_action :logs_cache_status_to_logstash
  end

  def retrieve_payload_data(retriever, cache: false, expires_in: nil)
    if cache && !bypass_cache?
      @cached_retriever = CacheResourceRetriever.call(
        retriever_organizer: retriever,
        retriever_params:,
        cache_key:,
        expires_in:
      )

      mark_response_as_cached_in_response!

      @cached_retriever
    else
      retriever.call(retriever_params)
    end
  end

  def cache_key
    fail NotImplementedError
  end

  def retriever_params
    {
      params: organizer_params,
      operation_id:,
      recipient:
    }
  end

  def bypass_cache?
    request.headers['Cache-Control'] == 'no-cache' || clogged_env?
  end

  def mark_response_as_cached_in_response!
    response.headers['X-Response-Cached'] = @cached_retriever.from_cache

    return unless @cached_retriever.from_cache
    return if @cached_retriever.expires_in.blank?

    response.headers['X-Cache-Expires-in'] = @cached_retriever.expires_in
  end

  def init_x_response_cached_header
    response.headers['X-Response-Cached'] = false
    response.headers['X-Cache-Expires-in'] = ''
  end

  def logs_cache_status_to_logstash
    LogStasher.store[:retriever_cached] = response.headers['X-Response-Cached']
  end

  def recipient
    @recipient ||= fetch_recipient
  end

  def fetch_recipient
    recipient = if france_connect?
                  params.fetch(:recipient, nil)
                else
                  params.fetch(:recipient, current_user.siret)
                end

    track_empty_recipient if recipient.blank?

    recipient
  end

  def track_empty_recipient
    monitoring_service.track_with_added_context(
      :warn,
      'Empty recipient',
      {
        france_connect: france_connect?,
        user_id: current_user&.id,
        user_siret: current_user&.siret,
        recipient_param: params[:recipient].presence
      }
    )
  end
end
