class DGFIP::Dictionaries < ApplicationInteractor
  def call
    @key = context.key

    dictionary = retrieve_dictionary

    context.dictionary = JSON.parse(dictionary) if dictionary
  end

  private

  def retrieve_dictionary
    cache_dictionary_from_remote unless retrieve_from_redis

    retrieve_from_redis
  end

  def cache_dictionary_from_remote
    DGFIP::Dictionaries::SaveInCacheFromRemote.call(params:).json_body
  end

  def params
    {
      year: year_from_key
    }
  end

  def year_from_key
    @key.split(':')[2].delete('year_')
  end

  def retrieve_from_redis
    RedisService.instance.get(@key)
  end
end
