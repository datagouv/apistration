class APIEntreprise::EditorDelegationRequestsController < APIEntrepriseController
  before_action :load_editor_delegation_request
  before_action :redirect_to_show, if: -> { @editor_delegation_request.submitted? }, except: :show
  before_action :redirect_to_show, unless: :agent_of_the_organization?, except: :show

  rescue_from DatapassAPIClient::Error, DatapassFormulaire::NotFound, with: :datapass_unavailable

  def show
    if @editor_delegation_request.submitted?
      render :submitted
    elsif !identified_for_an_organization?
      session[:return_to] = request.fullpath
      render :identification
    elsif agent_of_the_organization?
      redirect_to editor_delegation_request_data_protection_officer_path
    else
      render :organization_mismatch, status: :forbidden
    end
  end

  def edit; end

  def update
    @editor_delegation_request.assign_attributes(data_protection_officer_params)

    if params[:draft].present?
      save_draft
    elsif @editor_delegation_request.save(context: :data_protection_officer)
      redirect_to editor_delegation_request_summary_path
    else
      render :edit, status: :unprocessable_content
    end
  end

  def summary
    return redirect_to editor_delegation_request_data_protection_officer_path unless @editor_delegation_request.valid?(:data_protection_officer)

    @datapass_data = @editor_delegation_request.datapass_data
  end

  def submit
    @editor_delegation_request.assign_attributes(submission_params.merge(submitted_at: Time.zone.now, submitted_by_user: current_user))

    if @editor_delegation_request.save(context: :submission)
      redirect_to editor_delegation_request_path
    else
      @datapass_data = @editor_delegation_request.datapass_data
      render :summary, status: :unprocessable_content
    end
  end

  private

  def load_editor_delegation_request
    @editor_delegation_request = EditorDelegationRequest.find_by_token_for(:invitation, params[:token])

    raise ActionController::RoutingError, 'Not Found' if @editor_delegation_request.nil? || @editor_delegation_request.editor_slug != params[:editor_slug]

    @organization = Organization.find_by(siret: @editor_delegation_request.siret)
  end

  def save_draft
    @editor_delegation_request.save!

    success_message(title: 'Votre saisie est enregistrée, vous pourrez la reprendre plus tard depuis le même lien.')
    redirect_to editor_delegation_request_data_protection_officer_path
  end

  def identified_for_an_organization?
    user_signed_in? && session[:current_user_siret].present?
  end

  def agent_of_the_organization?
    identified_for_an_organization? &&
      session[:current_user_siret].first(9) == @editor_delegation_request.siret.first(9)
  end

  def redirect_to_show
    redirect_to editor_delegation_request_path
  end

  def datapass_unavailable
    render :datapass_unavailable, status: :service_unavailable
  end

  def data_protection_officer_params
    params.expect(editor_delegation_request: EditorDelegationRequest::DATA_PROTECTION_OFFICER_ATTRIBUTES)
  end

  def submission_params
    params.permit(:terms_of_service_accepted, :data_protection_officer_informed)
  end
end
