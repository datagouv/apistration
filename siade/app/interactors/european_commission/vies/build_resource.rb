class EuropeanCommission::VIES::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      tva_number:
    }
  end

  def tva_number
    context.tva_number
  end
end
