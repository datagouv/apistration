class INPI::RNE::Download::MakeRequest < INPI::RNE::MakeRequest
  SAMPLE_DOCUMENT_URL = 'https://raw.githubusercontent.com/datagouv/apistration/refs/heads/develop/mocks/payloads/api_entreprise_v3_inpi_rne_actes_bilans/exemple-bilan-inpi.pdf'.freeze

  protected

  def mock_call
    context.mocked_data = {
      status: 200,
      payload: {
        data: {
          document_url: SAMPLE_DOCUMENT_URL,
          expires_in: 1.day.to_i
        },
        links: {},
        meta: {}
      }
    }
  end

  def operation_id
    'api_entreprise_inpi_rne_download'
  end
end
