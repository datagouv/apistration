class Infogreffe::MandatairesSociauxSerializer::V3 < JSONAPI::BaseSerializer
  set_type :mandataires_sociaux

  attributes :id,
    :fonction

  attribute :nom, if: proc { |o| o.type == 'pp' }
  attribute :prenom, if: proc { |o| o.type == 'pp' }
  attribute :date_naissance, if: proc { |o| o.type == 'pp' }
  attribute :date_naissance_timestamp, if: proc { |o| o.type == 'pp' }
  attribute :lieu_naissance, if: proc { |o| o.type == 'pp' }
  attribute :pays_naissance, if: proc { |o| o.type == 'pp' }
  attribute :code_pays_naissance, if: proc { |o| o.type == 'pp' }
  attribute :nationalite, if: proc { |o| o.type == 'pp' }
  attribute :code_nationalite, if: proc { |o| o.type == 'pp' }

  attribute :raison_sociale, if: proc { |o| o.type == 'pm' }
  attribute :code_greffe, if: proc { |o| o.type == 'pm' }
  attribute :libelle_greffe, if: proc { |o| o.type == 'pm' }
  attribute :identifiant, if: proc { |o| o.type == 'pm' }
end
