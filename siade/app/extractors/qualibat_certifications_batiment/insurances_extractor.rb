class QUALIBATCertificationsBatiment::InsurancesExtractor < PDFExtractor
  def extract
    @extract ||= assurances
  end

  def self.insurances_names
    AppConfig.config_for('qualibat/insurance_names')
  end

  private

  def assurances
    assurances_kinds.transform_values { |label| assurance_payload(label) }
  end

  def assurance_payload(label)
    label_index = first_page_chunks.index { |chunk| chunk.include?(label) }

    return label_not_found(label) if label_index.nil?

    candidate_values = first_page_chunks[label_index + 1, 2].map { |chunk| sanitized_assurance_value(chunk) }

    first_named_assurance_payload(candidate_values) || name_not_found(candidate_values.last)
  end

  def first_named_assurance_payload(candidate_values)
    candidate_values.each do |assurance_value|
      assurance_name = insurances_names.find { |insurance_name| assurance_value.include?(insurance_name) }

      return build_assurance_payload(assurance_name, assurance_value) if assurance_name
    end

    nil
  end

  def name_not_found(assurance_value)
    track_not_found(assurance_value)

    empty_assurance_payload
  end

  def label_not_found(label)
    track_label_not_found(label)

    empty_assurance_payload
  end

  def assurances_kinds
    {
      assurance_responsabilite_travaux: 'Assurance Responsabilité Travaux',
      assurance_responsabilite_civile: 'Assurance Responsabilité Civile'
    }
  end

  def sanitized_assurance_value(chunk)
    chunk.strip.split(' ' * 10).first.to_s.strip
  end

  def build_assurance_payload(assurance_name, assurance_value)
    {
      nom: assurance_name,
      identifiant: assurance_value.sub("#{assurance_name} ", '')
    }
  end

  def empty_assurance_payload
    {
      nom: nil,
      identifiant: nil
    }
  end

  def track_not_found(assurance_value)
    monitoring_service.track_with_added_context(
      :info,
      '[Qualibat] No insurance name found',
      {
        assurance_value:
      }
    )
  end

  def track_label_not_found(label)
    monitoring_service.track_with_added_context(
      :info,
      '[Qualibat] Insurance label not found',
      {
        insurance_label: label
      }
    )
  end

  def first_page_chunks
    @first_page_chunks ||= pages[0].text.force_encoding('UTF-8').split("\n").reject(&:empty?)
  end

  def monitoring_service
    MonitoringService.instance
  end

  def insurances_names
    self.class.insurances_names
  end
end
