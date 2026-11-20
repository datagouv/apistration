class APIEntreprise::MI::SIAF::FondationsSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :identifiants,
    :identite,
    :activites,
    :filiation,
    :dirigeants

  attribute :beneficiaires_effectifs, if: -> { scope?(:fondations_mi_siaf_beneficiaires_effectifs) }

  attribute :situation_financiere do
    if scope?(:fondations_mi_siaf_controle)
      data.situation_financiere
    else
      data.situation_financiere.slice(:annees_subventions_publiques)
    end
  end
end
