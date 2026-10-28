module AuthorizationRequestMailersCommons
  extend ActiveSupport::Concern

  included do
    before_action :attach_logos

    include ExternalUrlHelper
  end

  class_methods do
    def authorization_request_emails(*methods)
      methods.each do |method|
        define_method(method) { |args| authorization_request_email(args) }
      end
    end
  end

  private

  def authorization_request_email(args)
    assign_authorization_request(args[:authorization_request])

    mail(to: extract_recipients(args[:to]), cc: extract_recipients(args[:cc]), subject: "n°#{@authorization_request.external_id} | #{t("mailers.authorization_request_mailer.#{action_name}.subject", api_name: api_full_name)} ")
  end

  def assign_authorization_request(authorization_request)
    @all_scopes = scope_labels
    @authorization_request = authorization_request
    @authorization_request_scopes = authorization_request.scopes.map(&:to_sym).presence
    @authorization_request_datapass_url = datapass_authorization_request_url(authorization_request)

    @full_name_demandeur = authorization_request.demandeur.full_name
    @full_name_contact_technique = authorization_request.contact_technique&.full_name
    @full_name_contact_metier = authorization_request.contact_metier&.full_name
  end

  def scope_labels
    I18n.t("api_#{namespace}.tokens.token.scope").transform_values { |scope| scope[:label] }
  end

  def extract_recipients(recipients)
    return if recipients.blank?

    Array(recipients).map do |recipient|
      contact = Hash.try_convert(recipient)
      contact ? contact[:email] || contact['email'] : recipient
    end
  end
end
