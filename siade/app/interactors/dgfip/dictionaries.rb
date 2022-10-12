class DGFIP::Dictionaries < ApplicationInteractor
  def call
    dictionary = retrieve_dictionary

    context.dictionary = JSON.parse(dictionary) if dictionary
  end

  private

  def retrieve_dictionary
    cache_dictionary_from_remote unless retrieve_from_redis

    retrieve_from_redis
  end

  def cache_dictionary_from_remote
    DGFIP::Dictionaries::SaveInCacheFromRemote.call(params: context.params)
  end

  def retrieve_from_redis
    RedisService.instance.get(key)
  end

  def key
    "dgfip:dictionnaires:#{year}"
  end

  def year
    context.params[:year]
  end
end
