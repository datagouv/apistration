class Editor::AuthorizationRequestTokensController < EditorController
  def create
    result = Token::CreateByEditor.call(authorization_request:, editor: current_editor, user: current_user)

    if result.success?
      success_message(title: t('.success.title', intitule: authorization_request.intitule))
    else
      error_message(title: t('.error.title'), description: result.message)
    end

    redirect_to editor_authorization_requests_path
  end

  private

  def authorization_request
    @authorization_request ||= current_editor
      .authorization_requests(api: namespace)
      .find(params.expect(:authorization_request_id))
  end
end
