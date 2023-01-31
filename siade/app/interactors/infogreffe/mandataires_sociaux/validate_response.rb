class Infogreffe::MandatairesSociaux::ValidateResponse < Infogreffe::ValidateResponse
  include Infogreffe::Concerns::MandatairesSociaux

  def call
    super

    return if any_mandataires_sociaux?

    resource_not_found!(:siren)
  end

  private

  def any_mandataires_sociaux?
    mandataires_sociaux_from_payload_personne_morale(document).any? ||
      mandataire_social_from_payload_personne_physique(document).any?
  end

  def document
    @document ||= Nokogiri.XML(body)
  end
end
