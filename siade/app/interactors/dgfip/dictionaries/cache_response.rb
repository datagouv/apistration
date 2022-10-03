class DGFIP::Dictionaries::CacheResponse < ApplicationInteractor
  def call
    dictionary.each { |imprime| save_in_redis(imprime) }
  end

  private

  def dictionary
    JSON.parse(context.response.body)['dictionnaire']
  end

  def save_in_redis(imprime)
    redis.set(redis_key(imprime), declarations(imprime), ex: dictionary_expires_in)
  end

  def redis_key(imprime)
    "dgfip:dictionnaires:#{year}:#{numero(imprime)}:#{millesime(imprime)}"
  end

  def year
    "year_#{context.params[:year]}"
  end

  def numero(imprime)
    "imprime_#{imprime['numero_imprime']}"
  end

  def millesime(imprime)
    "millesime_#{imprime['millesimes']['millesime']}"
  end

  def declarations(imprime)
    imprime['millesimes']['declaration'].to_json
  end

  def dictionary_expires_in
    6.months.from_now.to_i
  end

  def redis
    @redis ||= RedisService.instance
  end
end
