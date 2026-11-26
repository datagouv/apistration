class INPI::RNE::Download::MakeRequest < INPI::RNE::MakeRequest
  include MockedSampleDocument

  SAMPLE_DOCUMENT_URL = 'https://raw.githubusercontent.com/datagouv/apistration/refs/heads/develop/mocks/payloads/api_entreprise_v3_inpi_rne_actes_bilans/exemple-bilan-inpi.pdf'.freeze

  protected

  def operation_id
    'api_entreprise_inpi_rne_download'
  end
end
