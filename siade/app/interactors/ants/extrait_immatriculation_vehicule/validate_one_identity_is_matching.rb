class ANTS::ExtraitImmatriculationVehicule::ValidateOneIdentityIsMatching < ValidateResponse
  def call
    resource_not_found! unless matching_identity_exists?
  end

  private

  def matching_identity_exists?
    context.extracted_identities.any? do |identity|
      result = IdentityMatcher.call(
        candidate_identity: identity[:identite_from_ants],
        reference_identity: identite_pivot
      )
      result.success?
    end
  end

  def identite_pivot
    @identite_pivot ||= context[:params].slice(*matching_params)
  end

  def matching_params
    %i[
      nom_naissance
      prenoms
      sexe_etat_civil
      annee_date_naissance
      mois_date_naissance
      jour_date_naissance
      code_cog_insee_commune_naissance
    ]
  end
end
