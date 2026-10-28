module AuthorizationRequestMailersCommons
  extend ActiveSupport::Concern

  included do
    before_action :attach_logos

    include ExternalUrlHelper
  end

  %w[
    demande_recue
    embarquement_modifications_demandees
    embarquement_demande_refusee
    demande_validee
    jeton_disponible
  ].each do |method|
    define_method(method) { |args| authorization_request_email(args) }
  end

  private

  def authorization_request_email(args)
    @update = args[:update]
    assign_authorization_request(args[:authorization_request])
    assign_editors(args[:authorization_request])

    mail(to: extract_recipients(args[:to]), cc: extract_recipients(args[:cc]), subject: "n°#{@authorization_request.external_id} | #{t("mailers.authorization_request_mailer.#{action_name}.#{subject_key}", api_name: api_full_name)} ")
  end

  def assign_authorization_request(authorization_request)
    @authorization_request = authorization_request
    @authorization_request_datapass_url = datapass_authorization_request_url(authorization_request)
    @authorization_request_url = authorization_request_url(id: authorization_request.id)

    @full_name_demandeur = authorization_request.demandeur.full_name
    @full_name_contact_technique = authorization_request.contact_technique&.full_name
    @full_name_contact_metier = authorization_request.contact_metier&.full_name
  end

  def assign_editors(authorization_request)
    form_editors = Editor.for_demarche(authorization_request.demarche).to_a

    @delegated_editor = authorization_request.editor_delegations.active.map(&:editor).find(&:editor_tokens_enabled?)
    @token_generating_editor = form_editors.find(&:copy_token?) unless @delegated_editor
    @client_software_editor = form_editors.find(&:client_manages_token?)
  end

  def subject_key
    return 'update_subject' if @update
    return 'delegated_subject' if action_name == 'demande_validee' && (@delegated_editor || @token_generating_editor)

    'subject'
  end

  def extract_recipients(recipients)
    return if recipients.blank?

    Array(recipients).uniq.map do |recipient|
      contact = Hash.try_convert(recipient)
      contact ? contact[:email] || contact['email'] : recipient
    end
  end
end
