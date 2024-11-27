class INSEE::Successions::MakeRequest < INSEE::MakeRequest
  protected

  def request_uri
    URI([base_uri, 'entreprises', sirene_version, 'siret', 'liensSuccession'].join('/'))
  end

  def request_params
    {
      q: ["siretEtablissementSuccesseur:#{siret}", "siretEtablissementPredecesseur:#{siret}"].join(' OR ')
    }
  end

  private

  def siret
    context.params[:siret]
  end
end
