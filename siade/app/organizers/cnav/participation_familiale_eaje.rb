class CNAV::ParticipationFamilialeEAJE < CNAV::RetrieverOrganizer
  organize CNAV::ValidateParams,
    CNAV::Authenticate,
    CNAV::MakeRequest,
    CNAV::ParticipationFamilialeEAJE::ValidateResponse,
    CNAV::ParticipationFamilialeEAJE::BuildResource

  def call
    super
    build_attestation_proof
  rescue Interactor::Failure
    build_attestation_proof
    raise
  end

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'participation_familiale_eaje'
  end

  private

  def build_attestation_proof
    CNAV::ParticipationFamilialeEAJE::BuildAttestationProof.call(context)
  end
end
