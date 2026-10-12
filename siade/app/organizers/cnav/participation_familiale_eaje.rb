class CNAV::ParticipationFamilialeEAJE < CNAV::RetrieverOrganizer
  PROVABLE_NOT_FOUND_ORIGINS = {
    CNAV::ValidateResponse::ALLOCATAIRE_NOT_REFERENCED => 'RNCPS',
    CNAV::ValidateResponse::FILE_NOT_FOUND_PER_REGIME['CNAF'] => 'CNAF',
    CNAV::ValidateResponse::FILE_NOT_FOUND_PER_REGIME['MSA'] => 'MSA',
    CNAV::ParticipationFamilialeEAJE::ValidateResponse::ALLOCATAIRE_NOT_ELIGIBLE => :regime
  }.freeze

  PROVABLE_REGIMES = %w[CNAF MSA].freeze

  PROOF_FIELDS = %i[verification_token visual_code verification_url pdf_link_expires_at pdf_token].freeze

  around :prove_not_found

  organize CNAV::ValidateParams,
    CNAV::Authenticate,
    CNAV::MakeRequest,
    CNAV::ParticipationFamilialeEAJE::ValidateResponse,
    CNAV::ParticipationFamilialeEAJE::BuildResource,
    CNAV::ParticipationFamilialeEAJE::BuildAttestationProof

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'participation_familiale_eaje'
  end

  private

  def prove_not_found(organizer)
    organizer.call
  rescue Interactor::Failure
    prove(context.errors.first&.to_h&.deep_stringify_keys)
    raise
  end

  def prove(error)
    return if context.generate_proof_mode.blank? || error.nil?

    origin = not_found_origin(error)
    return if origin.nil?

    context.not_found_error = error.slice('title', 'detail').merge('origin' => origin)
    build_not_found_proof
  end

  def build_not_found_proof
    CNAV::ParticipationFamilialeEAJE::BuildNotFoundAttestationProof.call(context)
  rescue StandardError => e
    drop_proof
    MonitoringService.instance.track_with_added_context('error', "[#{provider_name}] EAJE not found proof could not be built", { exception: e.class.name, message: e.message })
  end

  def drop_proof
    PROOF_FIELDS.each { |field| context[field] = nil }
  end

  def not_found_origin(error)
    _, origin = PROVABLE_NOT_FOUND_ORIGINS.find do |declaration, _|
      declaration.options.values_at(:title, :provider) == [error['title'], error.dig('meta', 'provider')]
    end

    origin == :regime ? regime : origin
  end

  def regime
    REGIME_CODE_LABEL[context.response&.header&.[]('X-APISECU-FD')].presence_in(PROVABLE_REGIMES)
  end
end
