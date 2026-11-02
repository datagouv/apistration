class DGFIP::TVA::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      numero_tva: context.numero_tva,
      date_derniere_mise_a_jour: context.date_derniere_mise_a_jour
    }
  end
end
