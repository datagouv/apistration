class DatapassForm < ApplicationRecord
  RETENTION_KEY = 'duree_conservation_donnees_caractere_personnel'.freeze
  RECIPIENTS_KEY = 'destinataire_donnees_caractere_personnel'.freeze

  validates :uid, presence: true, uniqueness: true
  validates :api, inclusion: { in: Editor::APIS }

  scope :for_api, ->(api) { where(api:) }

  def editor_specific?
    data.key?('description')
  end

  def data_retention_months
    Integer(data[RETENTION_KEY], exception: false)
  end

  def data_recipients
    data[RECIPIENTS_KEY].presence
  end
end
