module INPI::RNE::ExtraitRNE::Concerns::ObservationExtractor
  include INPI::RNE::ExtraitRNE::Concerns::Constants
  include INPI::RNE::ExtraitRNE::Concerns::DataFormatters

  def extract_observations
    rcs_observations + rnm_observations
  end

  def rcs_observations
    format_rcs_observations(extract_rcs_observations_data)
  end

  def rnm_observations
    format_rnm_observations(content['inscriptionsOffices'] || [])
  end

  def extract_rcs_observations_data
    content.dig('personneMorale', 'observations', 'rcs') || []
  end

  def format_rnm_observations(observations)
    observations.map do |obs|
      build_observation_hash(FOURNISSEUR_RNM, nil, obs['dateEffet'], obs['observationComplementaire'])
    end
  end

  def format_rcs_observations(observations)
    observations.map do |obs|
      build_observation_hash(FOURNISSEUR_RCS, obs['numObservation'], obs['dateAjout'], fix_encoding(obs['texte']))
    end
  end

  def build_observation_hash(fournisseur, numero, date, texte)
    {
      fournisseur: fournisseur,
      numero: numero,
      date: format_date(date),
      texte: texte
    }
  end
end
