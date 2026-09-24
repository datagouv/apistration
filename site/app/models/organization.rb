class Organization < ApplicationRecord
  has_many :authorization_requests,
    foreign_key: :siret,
    inverse_of: :organization,
    dependent: nil

  validates :siret,
    presence: true,
    uniqueness: true,
    format: { with: /\A\d{14}\z/ }

  def denomination
    insee_payload_value('etablissement', 'uniteLegale', 'denominationUniteLegale')
  end

  def code_commune_etablissement
    insee_payload_value('etablissement', 'adresseEtablissement', 'codeCommuneEtablissement')
  end

  def code_postal_etablissement
    insee_payload_value('etablissement', 'adresseEtablissement', 'codePostalEtablissement')
  end

  private

  def insee_payload_value(*keys)
    keys.reduce(insee_payload) do |node, key|
      Hash.try_convert(node)&.fetch(key, nil)
    end
  end
end
