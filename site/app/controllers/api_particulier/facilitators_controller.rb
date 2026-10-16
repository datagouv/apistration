class APIParticulier::FacilitatorsController < APIParticulierController
  ACCESS_SESSION_KEY = :api_particulier_facilitators_access
  LISTED_STATUSES = %w[validated revoked changes_requested submitted draft].freeze
  STATUS_FILTERS = {
    'validated' => %w[validated],
    'validated_or_in_progress' => %w[validated changes_requested submitted draft]
  }.freeze

  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render_password_form(:too_many_requests, :too_many_attempts) }

  before_action :forbid_caching_and_indexing!

  def show
    return render_password_form(:unauthorized) unless access_granted?

    @use_cases = APIParticulier::FacilitatorUseCase.all
    @authorization_requests = listed_authorization_requests
      .includes(:organization)
      .order(Arel.sql('validated_at DESC NULLS LAST, last_update DESC NULLS LAST, id'))
      .page(params[:page])
      .per(50)
  end

  def create
    if password_matches?(params[:password].to_s)
      session[ACCESS_SESSION_KEY] = password_fingerprint
      redirect_to api_particulier_facilitators_path
    else
      render_password_form(:unauthorized, :invalid_password)
    end
  end

  def destroy
    session.delete(ACCESS_SESSION_KEY)
    redirect_to api_particulier_facilitators_path
  end

  private

  def listed_authorization_requests
    AuthorizationRequest
      .for_api('particulier')
      .where(demarche: selected_use_cases.flat_map(&:form_uids))
      .where(status: STATUS_FILTERS.fetch(filter_params[:status], LISTED_STATUSES))
  end

  def selected_use_cases
    [APIParticulier::FacilitatorUseCase.find(filter_params[:use_case]) || APIParticulier::FacilitatorUseCase.all].flatten
  end

  def filter_params
    params.permit(:use_case, :status)
  end

  def render_password_form(status, error = nil)
    @error = error
    render :new, status:
  end

  def access_granted?
    password.present? &&
      ActiveSupport::SecurityUtils.secure_compare(session[ACCESS_SESSION_KEY].to_s, password_fingerprint)
  end

  def password_matches?(candidate)
    password.present? && ActiveSupport::SecurityUtils.secure_compare(candidate, password)
  end

  def password_fingerprint
    OpenSSL::HMAC.hexdigest('SHA256', Rails.application.secret_key_base, password)
  end

  def password
    AdminApientreprise.credentials[:api_particulier_facilitators_password]
  end

  def forbid_caching_and_indexing!
    no_store
    response.headers['X-Robots-Tag'] = 'noindex'
  end
end
