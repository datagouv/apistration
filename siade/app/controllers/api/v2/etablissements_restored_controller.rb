class API::V2::EtablissementsRestoredController < API::V2::BaseController
  def show
    authorize :etablissements

    if retriever.success?
      if siret_redirected_to_another_siret?
        redirect_to_new_siret
        return
      end

      if with_non_diffusable? || retriever.diffusable_commercialement?
        render json: {
          etablissement: etablissement,
          gateway_error: false
        }, status: retriever.http_code
      else
        render error_json(UnavailableForLegalReasonsError.new('INSEE', 'Le SIRET est non diffusable, pour y accéder référez-vous à notre documentation.'), status: 451)
      end
    else
      render_errors(retriever, gateway_error: true)
    end
  end

  private

  def siret_redirected_to_another_siret?
    retriever.siret_redirected_to_another_siret?
  end

  def redirect_to_new_siret
    redirect_to action:          :show,
      siret:           retriever.redirected_siret,
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

  def with_non_diffusable?
    params['non_diffusables'] == 'true'
  end

  def etablissement
    EtablissementSerializer::V2.new(retriever).as_json
  end

  def retriever
    @retriever ||= SIADE::V3::Retrievers::EtablissementsRestored.new(siret).tap(&:retrieve)
  end

  def siret
    filtered_params.require(:siret)
  end

  def filtered_params
    params.permit(:siret)
  end
end
