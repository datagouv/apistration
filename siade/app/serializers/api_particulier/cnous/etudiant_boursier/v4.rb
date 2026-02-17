class APIParticulier::CNOUS::EtudiantBoursier::V4 < APIParticulier::CNOUS::EtudiantBoursier::V3
  attribute :est_boursier, if: -> { false }

  attribute :statut_boursier, if: -> { scope?(:cnous_statut_boursier) } do
    {
      est_boursier: data.est_boursier,
      est_radie: data.radiation[:est_radie],
      date_radiation: data.radiation[:date_radiation]
    }
  end
end
