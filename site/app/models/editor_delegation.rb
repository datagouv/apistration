class EditorDelegation < ApplicationRecord
  belongs_to :editor
  belongs_to :authorization_request

  enum :created_via, {
    manual: 'manual',
    datapass_auto: 'datapass_auto'
  }

  scope :active, -> { where(revoked_at: nil) }
  scope :revoked, -> { where.not(revoked_at: nil) }
end
