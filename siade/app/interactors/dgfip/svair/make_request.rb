class DGFIP::SVAIR::MakeRequest < MakeRequest::Post
  def request_uri
    URI('https://cfsmsp.impots.gouv.fr/secavis/faces/commun/index.jsf')
  end

  def form_data
    {
      'j_id_7:spi' => tax_number,
      'j_id_7:num_facture' => tax_notice_number,
      'j_id_7:j_id_l' => 'Valider',
      'j_id_7_SUBMIT' => '1',
      'javax.faces.ViewState' => scrap_current_view_state_value
    }
  end

  def set_headers(request)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
  end

  private

  def tax_number
    context.params[:tax_number]
  end

  def tax_notice_number
    context.params[:tax_notice_number]
  end

  def scrap_current_view_state_value
    svair_nodes = Nokogiri.XML(URI.parse(svair_url).open)
    view_state_value = svair_nodes.css('input[name="javax.faces.ViewState"]').attr('value')

    return view_state_value if view_state_value.present?

    unknown_provider_response!
  end

  def svair_url
    'https://cfsmsp.impots.gouv.fr/secavis/'
  end

  def unknown_provider_response!
    context.errors << ProviderUnknownError.new(context.provider_name)
    context.fail!
  end
end
