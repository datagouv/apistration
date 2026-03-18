class SIADE::V2::Responses::Associations < SIADE::V2::Responses::Generic

  protected

  def provider_name
    'RNA'
  end

  def adapt_raw_response_code
    if error_404?
      set_error_message_for(404)
    else
      @raw_response.code.to_i
    end
  end

  private

  def response_json
    @response_json ||= Hash.from_xml(@raw_response.body)
  end

  def error_hash
    @error_hash ||= response_json && response_json['asso'] && response_json['asso']['erreur']
  end

  def error_404?
    return false if contains_nom?

    no_result? ||
      not_found?
  end

  def no_result?
    error_hash && error_hash['proxy_correspondance'] && error_hash['proxy_correspondance']['lib'] == 'Aucun résultat'
  end

  def not_found?
    error_hash && error_hash['proxy_correspondance'] && error_hash['proxy_correspondance'].include?('statusCode: 404')
  end

  def contains_nom?
    !!response_json.dig('asso', 'identite', 'nom')
  end
end
