class EditorDelegation < ApplicationRecord
  belongs_to :editor
  belongs_to :authorization_request

  scope :active, -> { where(revoked_at: nil) }
end
