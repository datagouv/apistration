# Serializer for association model
class ConventionCollectiveSerializer::V2 < ActiveModel::Serializer
  attribute :siret
  attribute :conventions
end
