class EditorUseCase < ApplicationRecord
  belongs_to :editor

  has_many :editor_delegation_requests,
    dependent: :restrict_with_exception

  validates :datapass_form_uid, presence: true, uniqueness: { scope: :editor_id }

  def datapass_data
    DatapassFormulaire.find(datapass_form_uid).data.merge(data)
  end
end
