class Admin::Editors::FetchOrganization < ApplicationInteractor
  def call
    return unless context.editor.saved_change_to_siret? && context.editor.siret.present?

    organization = Organization.find_or_create_by(siret: context.editor.siret)
    UpdateOrganizationINSEEPayloadJob.perform_later(organization.id)
  end
end
