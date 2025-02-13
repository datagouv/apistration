class DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote < ApplicationInteractor
  def call
    if retriever.success?
      affect_dictionary_from_retriever
    elsif local_file_exists?
      affect_dictionary_from_local
    else
      handle_errors
    end
  end

  private

  def affect_dictionary_from_retriever
    context.dictionary = retriever.bundled_data.data.dictionnaire
  end

  def affect_dictionary_from_local
    context.dictionary = JSON.parse(File.read(local_file_path))

    track_local_load
  end

  def handle_errors
    context.errors = retriever.errors
    context.fail!
  end

  def retriever
    @retriever ||= CacheResourceRetriever.call(
      retriever_organizer:,
      retriever_params:,
      cache_key:,
      expires_in:
    )
  end

  def local_file_exists?
    File.exist?(local_file_path)
  end

  def local_file_path
    Rails.root.join('config', 'dgfip', 'dictionnaires', "#{year}.json")
  end

  def retriever_organizer
    DGFIP::Dictionaries
  end

  def retriever_params
    {
      params: {
        year:,
        user_id:,
        request_id:
      }
    }
  end

  def cache_key
    "dgfip:dictionnaires:#{year}"
  end

  def track_local_load
    MonitoringService.instance.track_with_added_context(
      'info',
      'Fail to fetch DGFIP dictionnary',
      {
        year:
      }
    )
  end

  def year
    context.year || context.params[:year]
  end

  def user_id
    context.params.fetch(:user_id)
  end

  def request_id
    context.params.fetch(:request_id)
  end

  def expires_in
    6.months.from_now.to_i
  end
end
