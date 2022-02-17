class Infogreffe::ExtraitsRCS::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      id: context.params[:siren],
      date_extrait: dossier['date_extrait'],
      date_immatriculation: dossier['dateISO_immat'],
      observations: build_observations
    }
  end

  private

  def infos
    @infos ||= Nokogiri.XML(body)
  end

  def dossier
    infos.css('dossier').first
  end

  def build_observations
    infos.css('liste_observations observation').map do |observation|
      {
        numero: observation.attribute('numero').value,
        libelle: observation.css('libelle').text.strip,
        date: observation.attribute('dateISO').value
      }
    end
  end
end
