class DGFIP::TVA::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      numero_tva: context.tva_number,
      date_derniere_mise_a_jour: context.date_derniere_mise_a_jour
    }
  end
end
