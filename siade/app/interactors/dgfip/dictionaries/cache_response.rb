class DGFIP::Dictionaries::CacheResponse < ApplicationInteractor
  def call
    redis.set(redis_key, dictionary, ex: dictionary_expires_in)
  end

  private

  def dictionary
    JSON.parse(context.response.body)['dictionnaire'].to_json
  end

  def redis_key
    "dgfip:dictionnaires:#{year}"
  end

  def year
    context.params[:year]
  end

  def dictionary_expires_in
    6.months.from_now.to_i
  end

  def redis
    @redis ||= RedisService.instance
  end
end
