class CNAV::FoyerRSA::MakeRequest < MockedInteractor
  include CivilityMockingParams

  FILE_NOT_FOUND = raises ::NotFoundError,
    provider: 'CNAV',
    title: 'Dossier non trouvé',
    detail: "Le dossier allocataire n'a pas été trouvé auprès de la CNAV."

  def call
    super

    return unless context.status == 404

    context.errors = [build_declared_error(FILE_NOT_FOUND)]
    context.fail!
  end

  protected

  def request_uri
    fail NotImplementedError
  end

  def request_params
    fail NotImplementedError
  end

  private

  def cnav_domain
    Siade.credentials[:cnav_domain]
  end
end
