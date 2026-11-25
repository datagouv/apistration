class DatapassWebhook::UpdateBrevoContacts < ApplicationInteractor
  def call
    brevo_contacts.each do |brevo_contact|
      brevo_api_client.upsert_contact(**brevo_contact, list_ids: [list_id])
    end
  end

  private

  def brevo_contacts
    [
      brevo_contact_for(:demandeur),
      brevo_contact_for(:contact_metier),
      brevo_contact_for(:contact_technique)
    ].compact.uniq do |brevo_contact|
      brevo_contact[:email]
    end
  end

  def brevo_contact_for(kind)
    contact = authorization_request.send(kind)

    return if contact.nil?
    return if contact.email.nil?

    {
      email: contact.email,
      attributes: {
        'PRENOM' => contact.first_name,
        'NOM' => contact.last_name
      }.merge(role_attributes_for(contact.email))
    }
  end

  def role_attributes_for(email)
    attributes = {
      'CONTACT_DEMANDEUR' => email == authorization_request.demandeur.try(:email),
      'CONTACT_TECHNIQUE' => email == authorization_request.contact_technique.try(:email)
    }

    attributes['CONTACT_METIER'] = (email == authorization_request.contact_metier.try(:email)) if authorization_request.api == 'entreprise'

    attributes
  end

  def list_id
    BrevoSettings.list_id(authorization_request.api)
  end

  def brevo_api_client
    @brevo_api_client ||= BrevoAPIClient.new
  end

  def authorization_request
    context.authorization_request
  end
end
