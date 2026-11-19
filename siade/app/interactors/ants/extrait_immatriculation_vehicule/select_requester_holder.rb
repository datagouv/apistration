class ANTS::ExtraitImmatriculationVehicule::SelectRequesterHolder < ValidateResponse
  raises ANTSError, kind: :no_matching_identity

  def call
    holder = use_mocked_data? ? physical_holders.first : matching_holder

    no_matching_identity! unless holder

    context.holder = holder
    context.matchings ||= { 'familyname' => true, 'givenname' => true }
    context.matches = true if context.matches.nil?
  end

  private

  def dossier
    json_body['listeDossiers'].first
  end

  def physical_holders
    Array(dossier.dig('personne', 'qualiteType')).select do |qualite|
      qualite.dig('identite', 'estPhysique')
    end
  end

  def matching_holder
    physical_holders.find do |qualite|
      result = IdentityMatcher.call(
        candidate_identity: candidate_identity(qualite['identite']),
        reference_identity: context.params.slice(:nom_naissance, :prenoms, :annee_date_naissance, :mois_date_naissance, :jour_date_naissance)
      )

      next false unless result.success?

      context.matchings = result.matchings
      context.matches = result.matches
      true
    end
  end

  def candidate_identity(identite)
    naissance = identite['naissance'] || {}
    date_parts = naissance['date']&.split('-')

    {
      nom_naissance: identite['nomNaiss'],
      prenoms: identite['prenom'].to_s.split,
      annee_date_naissance: date_parts&.[](0)&.to_i,
      mois_date_naissance: date_parts&.[](1)&.to_i,
      jour_date_naissance: date_parts&.[](2)&.to_i
    }.compact
  end

  def no_matching_identity!
    track_no_matching_identity

    fail_with_error!(ANTSError.new(:no_matching_identity))
  end

  def track_no_matching_identity
    MonitoringService.instance.track_with_added_context(
      'info',
      "[#{context.provider_name}] No matching identity found",
      { encrypted_params: DataEncryptor.new(context.params.to_json).encrypt.to_s }
    )
  end
end
