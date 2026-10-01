class EditorDelegation < ApplicationRecord
  belongs_to :editor
  belongs_to :authorization_request

  enum :created_via, {
    manual: 'manual',
    datapass_auto: 'datapass_auto',
    editor_delegation_request: 'editor_delegation_request'
  }

  scope :active, -> { where(revoked_at: nil) }
  scope :revoked, -> { where.not(revoked_at: nil) }
end
