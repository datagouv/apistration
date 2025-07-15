require_relative 'concerns/constants'
require_relative 'concerns/data_formatters'
require_relative 'concerns/entreprise_extractor'
require_relative 'concerns/etablissement_extractor'
require_relative 'concerns/dirigeant_extractor'
require_relative 'concerns/observation_extractor'
require_relative 'concerns/url_generator'

class INPI::RNE::ExtraitRNE::BuildResource < BuildResource
  include Rails.application.routes.url_helpers
  include INPI::RNE::ExtraitRNE::Concerns::Constants
  include INPI::RNE::ExtraitRNE::Concerns::DataFormatters
  include INPI::RNE::ExtraitRNE::Concerns::EntrepriseExtractor
  include INPI::RNE::ExtraitRNE::Concerns::EtablissementExtractor
  include INPI::RNE::ExtraitRNE::Concerns::DirigeantExtractor
  include INPI::RNE::ExtraitRNE::Concerns::ObservationExtractor
  include INPI::RNE::ExtraitRNE::Concerns::UrlGenerator

  protected

  def resource_attributes
    {
      document_url: link(target: 'extrait', document_id: siren),
      identite_entreprise: extract_entreprise,
      dirigeants_et_associes: extract_dirigeants,
      etablissements: extract_etablissements_actifs,
      diffusion_commerciale: formality['diffusionCommerciale'] || false,
      diffusion_insee: formality['diffusionINSEE'] == DIFFUSION_INSEE_OUI || false,
      etablissements_fermes_total: count_etablissements_fermes,
      observations: extract_observations
    }
  end

  private

  def formality
    @formality ||= json_body['formality'] || {}
  end

  def content
    @content ||= formality['content'] || {}
  end

  def personne
    @personne ||= personne_morale.presence || personne_physique
  end

  def personne_morale
    @personne_morale ||= content['personneMorale'] || {}
  end

  def personne_physique
    @personne_physique ||= content['personnePhysique'] || {}
  end

  def siren
    formality['siren'] || json_body['siren']
  end

  def entreprise_data
    @entreprise_data ||= personne.dig('identite', 'entreprise') || {}
  end

  def composition
    @composition ||= personne['composition'] || {}
  end

  def pouvoirs
    @pouvoirs ||= composition['pouvoirs'] || []
  end

  def commissaires_data
    @commissaires_data ||= composition['commissairesAuxComptes'] || []
  end

  def beneficiaires_data
    @beneficiaires_data ||= personne['beneficiairesEffectifs'] || []
  end

  def nature_creation
    @nature_creation ||= content['natureCreation'] || {}
  end

  def identite
    @identite ||= personne['identite'] || {}
  end

  def description
    @description ||= identite['description'] || {}
  end

  def extract_if_personne_present(default_value = [])
    return default_value if personne.blank?

    yield
  end

  def extract_entities(collection_method, &)
    extract_if_personne_present([]) do
      send(collection_method).filter_map(&)
    end
  end
end
