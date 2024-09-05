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
        date: Date.parse(payment['datePaiement']),
        montant: payment['montantPaiement'],
        allocations: payment['allocations'],
        aides: payment['aides'],
        autres: payment['autresPaiements']
      }
    end
  end
end
