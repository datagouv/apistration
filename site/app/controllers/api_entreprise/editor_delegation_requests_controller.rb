class APIEntreprise::EditorDelegationRequestsController < APIEntrepriseController
  layout 'api_entreprise/minimal'

  before_action :load_editor_delegation_batch
  before_action :redirect_to_show, unless: :signatory?, except: %i[show simulate_datapass_webhook]
  before_action :redirect_to_confirmation, if: -> { @batch.pending_requests.empty? }, only: %i[sign organizations edit_organization update_organization]
  before_action :load_organization, only: %i[edit_organization update_organization]
  before_action :ensure_datapass_webhook_simulation_allowed!, only: :simulate_datapass_webhook

  rescue_from DatapassAPIClient::Error, DatapassFormulaire::NotFound, with: :datapass_unavailable

  def show
    if !user_signed_in?
      session[:return_to] = request.fullpath
      render :identification
    elsif !signatory?
      render :account_mismatch, status: :forbidden
    elsif @batch.pending_requests.empty?
      redirect_to_confirmation
    else
      @signature = EditorDelegationBatch::Signature.new(batch: @batch, user: current_user)
      render :signature
    end
  end

  def sign
    @signature = EditorDelegationBatch::Signature.new(batch: @batch, user: current_user, **signature_params)

    if @signature.save
      redirect_to_confirmation
    else
      render :signature, status: :unprocessable_content
    end
  end

  def confirmation
    @submitted_requests = @batch.submitted_requests.to_a
  end

  def organizations; end

  def edit_organization; end

  def update_organization
    if @organization.update_data_protection_officer(data_protection_officer_params)
      success_message(title: "Le délégué à la protection des données de #{@organization.name} est enregistré.")
      redirect_to editor_delegation_request_organizations_path
    else
      render :edit_organization, status: :unprocessable_content
    end
  end

  def simulate_datapass_webhook
    result = DatapassWebhook::V2::APIEntreprise.call(**SimulatedDatapassWebhook.new(@editor_delegation_request, params[:event]).payload)

    if result.success?
      success_message(title: "Webhook DataPass « #{params[:event]} » simulé")
    else
      error_message(title: "Échec du webhook DataPass « #{params[:event]} » simulé", description: result.message)
    end

    redirect_to editor_delegation_request_path
  end

  private

  def ensure_datapass_webhook_simulation_allowed!
    raise ActionController::RoutingError, 'Not Found' if Rails.env.production? || !@editor_delegation_request.submitted?
  end

  def load_editor_delegation_batch
    @editor_delegation_request = EditorDelegationRequest.find_by_token_for(:invitation, params[:token])

    raise ActionController::RoutingError, 'Not Found' if @editor_delegation_request.nil? || @editor_delegation_request.editor_slug != params[:editor_slug]

    @batch = EditorDelegationBatch.of(@editor_delegation_request)
  end

  def load_organization
    @organization = @batch.organization(params[:siren])

    raise ActionController::RoutingError, 'Not Found' if @organization.nil?
  end

  def signatory?
    @batch.signatory?(current_user)
  end

  def redirect_to_show
    redirect_to editor_delegation_request_path
  end

  def redirect_to_confirmation
    redirect_to editor_delegation_request_confirmation_path
  end

  def datapass_unavailable
    render :datapass_unavailable, status: :service_unavailable
  end

  def signature_params
    params.expect(signature: [:terms_of_service_accepted, :data_protection_officer_informed, { included_ids: [], data_protection_officer: EditorDelegationRequest::DATA_PROTECTION_OFFICER_ATTRIBUTES }])
      .to_h.symbolize_keys
  end

  def data_protection_officer_params
    params.expect(editor_delegation_request: EditorDelegationRequest::DATA_PROTECTION_OFFICER_ATTRIBUTES)
  end
end
