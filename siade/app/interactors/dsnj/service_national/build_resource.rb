class DSNJ::ServiceNational::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      statut_service_national:,
      commentaires: result['complement']
    }
  end

  private

  def statut_service_national
    {
      'En règle' => 'en_regle',
      'Pas en règle' => 'pas_en_regle',
      'Indéterminé' => 'indetermine',
      'Non concerné' => 'non_concerne'
    }[result['en_regle']]
  end

  def result
    json_body['results'].first
  end
end
