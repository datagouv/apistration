class FranceTravail::Indemnites::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      identifiant:,
      paiements: payments
    }
  end

  private

  def identifiant
    context.params[:identifiant]
  end

  def payments
    json_body['listePaiement'].map do |payment|
      {
        date_versement: Date.parse(payment['datePaiement']),
        montant_total: payment['montantPaiement'],
        montant_allocations: payment['allocations'],
        montant_aides: payment['aides'],
        montant_autres: payment['autresPaiements']
      }
    end
  end
end
