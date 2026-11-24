class EditorObservedIpsQuery
  PERIOD = 7.days
  STATEMENT_TIMEOUT = '2s'.freeze

  def initialize(editor)
    @editor = editor
  end

  def count
    AccessLog.transaction do
      AccessLog.connection.execute("SET LOCAL statement_timeout = '#{STATEMENT_TIMEOUT}'")
      recent_logs = AccessLog.since(PERIOD.ago)
      recent_logs.where(token_id: client_tokens).or(recent_logs.where(token_id: editor.tokens.select(:id))).distinct.count(:ip)
    end
  rescue ActiveRecord::QueryCanceled
    nil
  end

  private

  attr_reader :editor

  def client_tokens
    Token.where(authorization_request: AuthorizationRequest.where(demarche: editor.use_cases.with_form.select(:form_uid))).select(:id)
  end
end
