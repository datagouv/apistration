class CIBTP::AttestationCotisationsCongesPayesChomageIntemperies::UploadDocument < UploadDocumentOrganizer
  organize Documents::StoreFromBinary

  def source_file_content
    response.body
  end

  def file_type
    'pdf'
  end

  def filename
    'attestation_cotisations_conges_payes_chomage_intemperies_cibtp'
  end
end
