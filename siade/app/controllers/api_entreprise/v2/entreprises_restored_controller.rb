class APIEntreprise::V2::EntreprisesRestoredController < APIEntreprise::V2::BaseController
  def show
    authorize :entreprises

    if retriever_entreprise.success?
      if retriever_etablissement.success?
        check_numero_tva

        if siren_redirected_to_another_siren?
          redirect_to_new_siren
          return
        end

        if with_non_diffusable? || retriever_entreprise.diffusable_commercialement?
          render json: valid_response, status: best_http_code
        else
          render error_json(UnavailableForLegalReasonsError.new('INSEE', 'Le SIREN est non diffusable, pour y accéder référez-vous à notre documentation.'), status: 451)
        end
      else
        render json:   ErrorsSerializer.new(retriever_etablissement.errors, format: error_format).as_json.merge(gateway_error: true),
          status: best_http_code
      end
    else
      render_errors(retriever_entreprise, gateway_error: true)
    end
  end

  private

  def redirect_to_new_siren
    redirect_to action:          :show,
      siren:           retriever_entreprise.redirected_siren,
      context:         params[:context],
      recipient:       params[:recipient],
      object:          params[:object],
      non_diffusables: params[:non_diffusables],
      token:           params[:token],
      status:          :moved_permanently

    response.body = body_details
  end

  def body_details
    ERB.new(
      File.read(
        Rails.root.join('app', 'views', 'api', 'v2', 'insee_redirection.erb')
      )
    ).result(binding)
  end

  def siren_redirected_to_another_siren?
    retriever_entreprise.siren_redirected_to_another_siren?
  end

  def with_non_diffusable?
    params['non_diffusables'] == 'true'
  end

  def best_http_code
    SIADE::V2::Utilities::HTTPCode.generate_best_http_code(
      [
        retriever_entreprise.http_code,
        retriever_etablissement.http_code
      ]
    )
  end

  def valid_response
    {
      entreprise: entreprise.as_json,
      etablissement_siege: etablissement_siege.as_json,
      gateway_error: false
    }
  end

  def entreprise
    APIEntreprise::EntrepriseSerializer::V2.new(
      retriever_entreprise,
      with_non_diffusable: with_non_diffusable?
    )
  end

  def etablissement_siege
    APIEntreprise::EtablissementSerializer::V2.new(retriever_etablissement)
  end

  def retriever_entreprise
    @retriever_entreprise ||= SIADE::V2::Retrievers::EntreprisesRestored.new(siren).tap(&:retrieve)
  end

  def retriever_etablissement
    @retriever_etablissement ||= SIADE::V2::Retrievers::EtablissementsRestored.new(siret).tap(&:retrieve)
  end

  def siret
    retriever_entreprise.siret_siege_social
  end

  def siren
    filtered_params.require(:siren)
  end

  def check_numero_tva
    retriever_entreprise.numero_tva_intracommunautaire = nil if foreign_siege_social?
  end

  def foreign_siege_social?
    !retriever_etablissement.adresse[:adresse_francaise?]
  end

  def filtered_params
    params.permit(:siren)
  end
end
