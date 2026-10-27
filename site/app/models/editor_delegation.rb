class EditorDelegation < ApplicationRecord
  belongs_to :editor
  belongs_to :authorization_request

  enum :created_via, {
    manual: 'manual',
    datapass_auto: 'datapass_auto',
    editor_delegation_request: 'editor_delegation_request'
  }

  validate :editor_serves_authorization_request_api, on: :create

  scope :active, -> { where(revoked_at: nil) }
  scope :revoked, -> { where.not(revoked_at: nil) }

  private

  def editor_serves_authorization_request_api
    return if editor.nil? || authorization_request.nil?
    return if editor.serves_api?(authorization_request.api)

    errors.add(:editor, :api_mismatch)
  end
end
