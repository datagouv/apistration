class EditorDelegationCampaign < ApplicationRecord
  APIS = %w[entreprise particulier].freeze

  belongs_to :editor

  has_many :editor_delegation_requests,
    dependent: :restrict_with_exception

  validates :api, inclusion: { in: APIS }
  validates :datapass_form_uid, presence: true, uniqueness: { scope: :editor_id }

  def datapass_data
    DatapassFormulaire.find(datapass_form_uid, api:).data.merge(data)
  end

  def datapass_definition
    DatapassDefinition.find(api)
  end
end
