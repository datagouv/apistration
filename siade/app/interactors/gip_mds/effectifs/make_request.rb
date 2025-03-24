class GIPMDS::Effectifs::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("#{mds_domain}#{mds_path}")
  end

  def mocking_params
    {
      siren: context.params[:siren],
      year: context.params[:year],
      siret: context.params[:siret],
      month: context.params[:month]
    }.compact
  end

  def request_params
    {
      codeOPSDemandeur: code_demandeur_dinum,
      dateHeure: current_time_as_iso_8601,
      source: regime_agricole_and_regime_general_acronym,
      nature:
    }.merge(build_time_params)
  end

  def extra_headers(request)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{token}"
  end

  def extra_http_start_options
    {
      open_timeout: 2,
      read_timeout: 6
    }
  end

  private

  def build_time_params
    case context.params[:nature]
    when :yearly
      annual_params
    when :monthly
      monthly_params
    end
  end

  def nature
    case context.params[:nature]
    when :yearly
      'A01'
    when :monthly
      'M01'
    end
  end

  def annual_params
    {
      siren: context.params[:siren],
      periode: "#{context.params[:year]}1231"
    }
  end

  def monthly_params
    {
      siret: context.params[:siret],
      periode: "#{context.params[:year]}#{context.params[:month]}01",
      profondeurHistorique: depth
    }.compact
  end

  def depth
    context.params[:depth]
  end

  def token
    context.token
  end

  def mds_domain
    Siade.credentials[:gip_mds_domain]
  end

  def mds_path
    '/rcd-api/1.0.0/effectifs'
  end

  def current_time_as_iso_8601
    Time.zone.now.iso8601
  end

  def code_demandeur_dinum
    '00000DINUM'.freeze
  end

  def regime_agricole_and_regime_general_acronym
    'RA;RG'.freeze
  end
end
