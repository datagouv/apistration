class APIParticulier::ReportersController < APIParticulier::AuthenticatedUsersController
  before_action :check_if_reporter_or_admin

  helper_method :groups_for_reporter

  def index
    @authorization_requests = submitted_authorization_requests_for_groups
      .includes(:organization)
      .order(Arel.sql('last_update DESC NULLS LAST, first_submitted_at DESC, id'))
      .page(params[:page])
      .per(50)
  end

  private

  def submitted_authorization_requests_for_groups
    AuthorizationRequest
      .for_api('particulier')
      .submitted_at_least_once
      .where(
        'EXISTS (SELECT 1 FROM jsonb_array_elements_text(scopes) AS scope WHERE scope LIKE ANY (ARRAY[?]))',
        groups_for_reporter.map { |group| "#{AuthorizationRequest.sanitize_sql_like(group.to_s)}%" }
      )
  end

  def check_if_reporter_or_admin
    return if current_user.admin? || reporter_emails.include?(current_user.email)

    redirect_to root_path
  end

  def groups_for_reporter
    if current_user.admin?
      reporters_config.keys
    else
      reporters_config.select { |_, emails| emails.include?(current_user.email) }.keys
    end
  end

  def reporter_emails
    reporters_config.values.flatten.uniq
  end

  def reporters_config
    AdminApientreprise.credentials.fetch(:api_particulier_reporters, {})
  end
end
