class DGFIP::TVA::MakeRequest < MakeRequest::Get
  BASE_URL = 'https://tabular-api.data.gouv.fr'.freeze
  RESOURCE_ID = '5199cd40-0e9c-4a24-8ba3-c2365999b2aa'.freeze

  protected

  def mocking_params
    context.params
  end

  def request_uri
    URI("#{BASE_URL}/api/resources/#{RESOURCE_ID}/data/")
  end

  def request_params
    {
      vat_no__exact: tva_number_without_fr
    }
  end

  private

  def tva_number_without_fr
    context.tva_number[2..]
  end
end
