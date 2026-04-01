require 'zlib'

require_relative '../provider_stubs'

module ProviderStubs::BanqueDeFrance
  def mock_valid_banque_de_france
    json_body = open_payload_file('banque_de_france/bilans_entreprise_valid_data.json').read

    mock_banque_de_france(build_banque_de_france_response(json_body))
  end

  def mock_banque_de_france(data)
    stub_request(:get, /banque_de_france/).and_return(
      status: 200,
      body: data
    )
  end

  def build_banque_de_france_response(json_body)
    json_body
  end

  def retrieve_dgfip_dictionaries(years)
    years.each do |year|
      DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote.call(params: { year: })
    end
  end
end
