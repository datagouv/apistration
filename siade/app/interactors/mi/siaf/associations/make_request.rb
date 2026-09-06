class MI::SIAF::Associations::MakeRequest < MockedInteractor
  protected

  def mocking_params
    {
      siren_or_siret_or_rna: context.params[:siren_or_siret_or_rna]
    }
  end

  def request_uri
    fail NotImplementedError
  end

  def request_params
    fail NotImplementedError
  end

  private

  def siaf_domain
    Siade.credentials[:siaf_domain]
  end
end
