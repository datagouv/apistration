class ANTS::ExtraitImmatriculationVehicule::ValidateOneIdentityIsMatching < ValidateResponse
  def call
    matching_identity = find_matching_identity

    if matching_identity
      context.matched_identity = matching_identity
    else
      no_matching_identity!
    end
  end

  private

  def find_matching_identity
    context.extracted_identities.find do |identity|
      result = IdentityMatcher.call(
        candidate_identity: identity[:identite_from_ants],
        reference_identity: identite_pivot
      )

      if result.success?
        context.matchings = result.matchings
        context.matches = result.matches
        true
      else
        false
      end
    end
  end

  def identite_pivot
    @identite_pivot ||= context[:params].slice(*matching_params)
  end

  def matching_params
    %i[
      nom_naissance
      prenoms
      annee_date_naissance
      mois_date_naissance
      jour_date_naissance
    ]
  end

  def no_matching_identity!
    track_no_matching_identity

    fail_with_error!(
      ::NotFoundError.new(
        context.provider_name,
        'Immatriculation trouvée mais aucune identité ne correspond',
        title: 'Identité non trouvée',
        subcode: '005',
        with_identifiant_message: false
      )
    )
  end

  def track_no_matching_identity
    MonitoringService.instance.track_with_added_context(
      'info',
      "[#{context.provider_name}] No matching identity found",
      { encrypted_params: }
    )
  end

  def encrypted_params
    DataEncryptor.new(context.params.to_json).encrypt.to_s
  end
end
