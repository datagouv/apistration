class SIADE::V2::Drivers::INPI::Bilans < SIADE::V2::Drivers::GenericDriver
  attr_accessor :siren, :cookie

  default_to_nil_raw_fetching_methods :bilans

  def initialize(siren:, cookie:)
    @siren = siren
    @cookie = cookie
  end

  def request
    @request ||= SIADE::V2::Requests::INPI::FindDocuments.new(@siren, :bilans, @cookie)
  end

  def check_response; end

  def provider_name
    'INPI'
  end

  private

  def json_documents
    @json_documents ||= JSON.parse(response.body, symbolize_names: true)
  end

  def bilans_raw
    @actes_raw ||= build_documents_response
  end

  def build_documents_response
    json_documents.map do |document|
      {
        id_fichier:           document[:idFichier],
        siren:                document[:siren].to_s,
        denomination_sociale: document[:denomonationSociale],
        code_greffe:          document[:codeGreffe],
        date_depot:           document[:dateDepot],
        nature_archive:       document[:natureArchive],
        confidentiel:         document[:confidentiel],
        date_cloture:         document[:dateCloture],
        numero_gestion:       document[:numGestion]
      }
    end
  end
end
