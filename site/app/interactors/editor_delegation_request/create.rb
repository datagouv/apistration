class EditorDelegationRequest::Create < ApplicationInteractor
  def call
    ActiveRecord::Base.transaction { create_records }

    UpdateOrganizationINSEEPayloadJob.perform_later(context.organization.id)
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => e
    context.fail!(message: e.message)
  end

  private

  def create_records
    context.organization = Organization.find_or_create_by!(siret:)
    context.authorization_request = AuthorizationRequest.create!(authorization_request_attributes)
    create_editor_delegation
    context.editor_delegation_request = create_editor_delegation_request
  end

  def authorization_request_attributes
    {
      api: 'entreprise',
      demarche: editor_delegation_campaign.datapass_form_uid,
      siret:,
      status: 'draft',
      intitule: datapass_data['intitule'],
      description: datapass_data['description'],
      scopes: DatapassScopes.normalize(Array(datapass_data['scopes']))
    }
  end

  def create_editor_delegation
    EditorDelegation.create!(
      editor: editor_delegation_campaign.editor,
      authorization_request: context.authorization_request,
      created_via: 'editor_delegation_request'
    )
  end

  def create_editor_delegation_request
    EditorDelegationRequest.create!(
      editor_delegation_campaign:,
      siret:,
      contact_email: context.contact_email,
      authorization_request: context.authorization_request,
      **context.data_protection_officer.to_h
    )
  end

  def editor_delegation_campaign
    context.editor_delegation_campaign
  end

  def siret
    context.siret
  end

  def datapass_data
    context.datapass_data
  end
end
