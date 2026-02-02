class APIParticulier::CNOUS::EtudiantBoursier::V4 < APIParticulier::CNOUS::EtudiantBoursier::V3
  attribute :est_radie, if: -> { scope?(:cnous_statut_boursier) } do
    data.radiation[:est_radie]
  end

  attribute :date_radiation, if: -> { scope?(:cnous_statut_boursier) } do
    data.radiation[:date_radiation]
  end
end
