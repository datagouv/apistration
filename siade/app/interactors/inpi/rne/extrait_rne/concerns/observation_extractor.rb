module INPI::RNE::ExtraitRNE::Concerns::ObservationExtractor
  include INPI::RNE::ExtraitRNE::Concerns::Constants
  include INPI::RNE::ExtraitRNE::Concerns::DataFormatters

  def extract_observations
    sort_observations(rcs_observations + rnm_observations)
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
      fournisseur:,
      numero:,
      date: format_date(date),
      texte:
    }
  end

  def sort_observations(observations)
    observations.sort { |a, b| compare_observations_by_date(a, b) }
  end

  private

  def compare_observations_by_date(obs_a, obs_b)
    return compare_by_date(obs_a[:date], obs_b[:date]) if both_have_dates?(obs_a, obs_b)
    return observation_with_date_priority(obs_a, obs_b) if only_one_has_date?(obs_a, obs_b)

    0 # Both have no date, keep original order
  end

  def both_have_dates?(obs_a, obs_b)
    obs_a[:date] && obs_b[:date]
  end

  def only_one_has_date?(obs_a, obs_b)
    (obs_a[:date] && !obs_b[:date]) || (!obs_a[:date] && obs_b[:date])
  end

  def compare_by_date(date_a, date_b)
    Date.parse(date_b) <=> Date.parse(date_a) # newest first
  end

  def observation_with_date_priority(obs_a, _obs_b)
    obs_a[:date] ? -1 : 1 # observation with date comes first
  end
end
