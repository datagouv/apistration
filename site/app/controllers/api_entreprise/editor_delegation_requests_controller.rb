class APIEntreprise::EditorDelegationRequestsController < APIEntrepriseController
  layout 'api_entreprise/minimal'

  before_action :load_editor_delegation_batch
  before_action :redirect_to_show, unless: :signatory?, except: :show
  before_action :redirect_to_confirmation, if: -> { @batch.pending_requests.empty? }, only: %i[update_data_protection_officer verification sign organizations edit_organization update_organization]
  before_action :ensure_single_request!, only: %i[update_data_protection_officer verification]
  before_action :load_organization, only: %i[edit_organization update_organization]

  rescue_from DatapassAPIClient::Error, DatapassFormulaire::NotFound, with: :datapass_unavailable

  def show
    if !user_signed_in?
      session[:return_to] = request.fullpath
      render :identification
    elsif !signatory?
      render :account_mismatch, status: :forbidden
    else
      render_pending_requests
    end
  end

  def update_data_protection_officer
    @organization = @batch.organizations.first

    if @organization.update_data_protection_officer(data_protection_officer_params)
      redirect_to editor_delegation_request_verification_path
    else
      render :data_protection_officer, status: :unprocessable_content
    end
  end

  def verification
    return redirect_to_show unless @batch.organizations.first.data_protection_officer_complete?

    @signature = EditorDelegationBatch::Signature.new(batch: @batch, user: current_user)
  end

  def sign
    @signature = EditorDelegationBatch::Signature.new(batch: @batch, user: current_user, **signature_params)

    if @signature.save
      redirect_to_confirmation
    else
      render @batch.single? ? :verification : :signature, status: :unprocessable_content
    end
  end

  def confirmation
    @submitted_requests = @batch.submitted_requests.includes(:authorization_request).to_a
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

  private

  def render_pending_requests
    if @batch.pending_requests.empty?
      redirect_to_confirmation
    elsif @batch.single?
      @organization = @batch.organizations.first
      render :data_protection_officer
    else
      @signature = EditorDelegationBatch::Signature.new(batch: @batch, user: current_user)
      render :signature
    end
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

  def ensure_single_request!
    redirect_to_show unless @batch.single?
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
