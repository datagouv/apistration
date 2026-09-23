class DGFIP::TVA::MakeRequest < MakeRequest::Get
  BASE_URL = 'https://tabular-api.data.gouv.fr'.freeze
  RESOURCE_ID = '5199cd40-0e9c-4a24-8ba3-c2365999b2aa'.freeze
  CACHE_BUSTING_FIRST_DATE = Date.new(1000, 1, 1)
  CACHE_BUSTING_DATES_COUNT = 300_000
  CACHE_BUSTING_PERIOD_IN_SECONDS = 1.hour.to_i

  protected

  def mocking_params
    context.params
  end

  def request_uri
    URI("#{BASE_URL}/api/resources/#{RESOURCE_ID}/data/")
  end

  def request_params
    {
      vat_no__exact: tva_number_without_fr,
      issued_date__greater: cache_busting_date
    }
  end

  private

  def tva_number_without_fr
    context.tva_number[2..]
  end

  def cache_busting_date
    hourly_bucket = Time.now.to_i / CACHE_BUSTING_PERIOD_IN_SECONDS

    (CACHE_BUSTING_FIRST_DATE + (hourly_bucket % CACHE_BUSTING_DATES_COUNT)).iso8601
  end
end
