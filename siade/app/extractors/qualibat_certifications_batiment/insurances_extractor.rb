class QUALIBATCertificationsBatiment::InsurancesExtractor < PDFExtractor
  def extract
    @extract ||= assurances
  end

  def self.insurances_names
    @insurances_names ||= Rails.application.config_for('qualibat/insurance_names')
  end

  private

  def assurances
    assurances_kinds.each_with_object({}) do |(key, text_to_match), assurances|
      extract_assurance(key, text_to_match, assurances)
    end
  end

  def extract_assurance(key, text_to_match, assurances)
    assurance_index = first_page_chunks.index { |chunk| chunk.include?(text_to_match) }

    2.times do |j|
      assurance_index += 1

      assurance_value = sanitized_assurance_value(assurance_index)
      assurance_name = insurances_names.find { |insurance_name| assurance_value.include?(insurance_name) }

      if assurance_name
        assurances[key] = build_assurance_payload(assurance_name, assurance_value)

        break
      elsif j == 1
        track_not_found(assurance_value)

        assurances[key] = empty_assurance_payload
      end
    end
  end

  def assurances_kinds
    {
      assurance_responsabilite_travaux: 'Assurance Responsabilité Travaux',
      assurance_responsabilite_civile: 'Assurance Responsabilité Civile'
    }
  end

  def sanitized_assurance_value(assurance_index)
    first_page_chunks[assurance_index].strip.split(' ' * 10)[0].strip
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
