require 'cgi'

class GenerateCodeSampleFromPath
  def initialize(path, params, api_kind)
    @path = path
    @params = params
    @api_kind = api_kind
  end

  def perform
    if api_kind == 'api_entreprise'
      api_entreprise_curl
    elsif api_kind == 'api_particulier_v2'
      api_particulier_v2_curl
    elsif api_kind == 'api_particulier'
      api_particulier_curl
    elsif api_kind == 'france_connect'
      france_connect_curl
    else
      raise 'Unknown API kind'
    end
  end

  private

  attr_reader :path, :params, :api_kind

  def api_entreprise_curl
    "curl -H \"Authorization: Bearer $token\" \\\n" \
      "  -G #{build_curl_query_params(api_entreprise_default_query_params)} \\\n" \
      "  --url \"https://staging.entreprise.api.gouv.fr#{interpolated_path}\""
  end

  def api_particulier_curl
    "curl -H \"Authorization: Bearer $token\" \\\n" \
      "  -G #{build_curl_query_params(api_particulier_default_query_params.merge(params))} \\\n" \
      "  --url \"https://staging.particulier.api.gouv.fr#{interpolated_path}\""
  end

  def api_particulier_v2_curl
    "curl -H \"X-Api-Key: $token\" \\\n" \
      "  -G #{build_curl_query_params(params)} \\\n" \
      "  --url \"https://staging.particulier.api.gouv.fr#{interpolated_path}\""
  end

  def france_connect_curl
    "curl -H \"Authorization: Bearer #{params['token'] || '$token_france_connect' }\" --url \"https://staging.particulier.api.gouv.fr#{interpolated_path}?recipient=13002526500013\""
  end

  def interpolated_path
    path.gsub("{", "%{") % params.transform_keys(&:to_sym)
  end

  def build_curl_query_params(query_params)
    query_params.map do |key, value|
      build_curl_query_param(key, value)
    end.flatten.join(' ')
  end

  def build_curl_query_param(key, value)
    if value.is_a?(Array)
      value.map { |v| build_curl_query_param("#{key}[]", v) }.join(' ')
    else
      "-d '#{key}=#{CGI.escape(value.to_s)}'"
    end
  end

  def api_entreprise_default_query_params
    {
      recipient: '10000001700010',
      context: 'Contexte de la requête',
      object: 'Objet de la requête',
    }
  end

  def api_particulier_default_query_params
    {
      recipient: '13002526500013'
    }
  end
end
