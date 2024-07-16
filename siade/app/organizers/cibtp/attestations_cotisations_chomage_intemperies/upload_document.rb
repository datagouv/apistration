class CIBTP::AttestationsCotisationsChomageIntemperies::UploadDocument < UploadDocumentOrganizer
  organize Documents::StoreFromBinary

  def source_file_content
    response.body
  end

  def file_type
    'pdf'
  end

  def filename
    'attestations_cotisations_chomage_intemperies_cibtp'
  end
end
