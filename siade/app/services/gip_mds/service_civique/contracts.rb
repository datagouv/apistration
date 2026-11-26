class GIPMDS::ServiceCivique::Contracts
  MOTIF_RUPTURE_ANNULATION = 99
  MOTIF_RUPTURE_MUTATION = 100
  MOTIFS_RUPTURE_CONTRAT_POURSUIVI = [MOTIF_RUPTURE_ANNULATION, MOTIF_RUPTURE_MUTATION].freeze

  def self.continuing?(contrat)
    MOTIFS_RUPTURE_CONTRAT_POURSUIVI.include?(contrat['motifRupture'].to_i)
  end

  def initialize(json_body)
    @json_body = json_body
  end

  def retained
    all.reject { |contract| transfer_followed_by_its_new_contract?(contract) }
  end

  private

  def transfer_followed_by_its_new_contract?(contract)
    transfer?(contract) && all.any? { |other| starts_after?(other, contract) }
  end

  def transfer?(contract)
    contract[:contrat]['motifRupture'].to_i == MOTIF_RUPTURE_MUTATION
  end

  def starts_after?(contract, reference)
    contract_start, reference_start = [contract, reference].map { |c| start_date(c) }

    contract_start.present? && reference_start.present? && contract_start > reference_start
  end

  def start_date(contract)
    Date.iso8601(contract[:contrat]['dateDebutContrat'].to_s)
  rescue Date::Error
    nil
  end

  def all
    @all ||= Array(@json_body.dig('individu', 'entreprise')).flat_map do |entreprise|
      Array(entreprise['etablissement']).flat_map do |etablissement|
        Array(etablissement['contrat']).map { |contrat| { siret: etablissement['siret'], contrat: } }
      end
    end
  end
end
