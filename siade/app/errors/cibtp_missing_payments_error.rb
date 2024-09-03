class CIBTPMissingPaymentsError < NotFoundError
  def initialize
    super(provider_name)
  end

  def provider_name
    'CIBTP'
  end

  def subcode
    '422'
  end

  def title
    'Attestation non disponible'
  end

  def detail
    "L'attestation ne peut être délivrée car l'entreprise n'est pas en règle de ses cotisations CIBTP."
  end
end
