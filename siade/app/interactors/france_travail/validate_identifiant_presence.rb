class FranceTravail::ValidateIdentifiantPresence < ValidateAttributePresence
  raises UnprocessableEntityError, field: :identifiant

  def attribute
    :identifiant
  end
end
