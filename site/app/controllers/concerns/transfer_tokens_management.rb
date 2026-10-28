module TransferTokensManagement
  def new
    @token = authorize(current_user.tokens.find(params.expect(:id)), :transfer?)

    render 'shared/transfer_tokens/new'
  end

  def create
    @token = Token.find(params.expect(:id))

    if transfer_allowed?
      if organizer.success?
        success_message(title: t('shared.transfer_tokens.create.success.title', target_email:))
      else
        error_message(title: t('shared.transfer_tokens.create.error.title', support_email: t("#{namespace}.support_email")))
      end

      redirect_to authorization_requests_path
    else
      head :forbidden
    end
  end

  private

  def transfer_allowed?
    TokenPolicy.new(current_user, @token).transfer?
  end

  def organizer
    @organizer ||= Token::DeliverMagicLinkToEmail.call(
      email: target_email,
      token_id: @token.id,
      expires_at: 4.hours.from_now,
      host: request.host
    )
  end

  def target_email
    params[:email]
  end
end
