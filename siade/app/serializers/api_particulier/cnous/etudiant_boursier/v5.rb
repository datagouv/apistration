class APIParticulier::CNOUS::EtudiantBoursier::V5 < APIParticulier::CNOUS::EtudiantBoursier::V4
  attribute :ine, if: -> { scope?(:cnous_ine) }
end
