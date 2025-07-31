class ANTS::ExtraitImmatriculationVehicule::MakeRequest < MockedInteractor
  protected

  def mocking_params
    {
      immatriculation: context.params[:immatriculation]
    }
  end

  def request_uri
    fail NotImplementedError
  end

  def request_params
    fail NotImplementedError
  end

  private

  def ants_domain
    Siade.credentials[:ants_domain]
  end
end
