module PublicTokenMagicLinksManagement
  extend ActiveSupport::Concern

  def show
    result = Token::AccessSharedLink.call(access_token: magic_token_show_params[:access_token])
    @magic_link = result.magic_link

    return handle_invalid_magic_link!(result.message) if result.failure?

    render 'shared/public_token_magic_links/show'
  end

  private

  def handle_invalid_magic_link!(reason)
    if reason == 'expired'
      handle_error!(reason, initial_expiration_delay_in_hours: @magic_link.initial_expiration_delay_in_hours)
    else
      handle_error!(reason)
    end
  end

  def handle_error!(error_type, i18n_params = {})
    error_message(
      title: t("#{namespace}.public_token_magic_links.show.error.#{error_type}.title"),
      description: t("#{namespace}.public_token_magic_links.show.error.#{error_type}.description", **i18n_params)
    )
    redirect_to login_path
  end

  def magic_token_show_params
    {
      access_token: params.require(:access_token)
    }
  end

  def api
    namespace.split('_').last
  end
end
