class Editor::API::BaseController < APIController
  BEARER_PATTERN = /\ABearer\s+(.+)\z/
  DEFAULT_PER_PAGE = 50
  MAX_PER_PAGE = 100

  before_action :authenticate_editor!

  private

  attr_reader :current_editor, :current_editor_token

  def authenticate_editor!
    token = extract_bearer_token
    return unauthorized if token.blank?

    payload = AccessToken.decode(token)
    return unauthorized unless payload[:editor] == true

    @current_editor_token = EditorToken.active.find_by(id: payload[:jti])
    return unauthorized if @current_editor_token.nil?

    @current_editor = @current_editor_token.editor
  rescue JWT::DecodeError
    unauthorized
  end

  def extract_bearer_token
    match = request.authorization&.match(BEARER_PATTERN)
    match && match[1].presence
  end

  def current_api
    EditorAPIDomainConstraint.api_for_host(request.host)
  end

  def per_page
    raw = params[:per_page]
    requested = raw.to_i
    return DEFAULT_PER_PAGE if requested <= 0

    [requested, MAX_PER_PAGE].min
  end

  def pagination_meta(scope)
    {
      page: scope.current_page,
      per_page: scope.limit_value,
      total: scope.total_count,
      total_pages: scope.total_pages
    }
  end
end
