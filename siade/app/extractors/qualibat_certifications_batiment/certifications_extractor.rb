class QUALIBATCertificationsBatiment::CertificationsExtractor < PDFExtractor
  def extract
    certifications
  end

  private

  # rubocop:disable Metrics/MethodLength
  def certifications
    certifications_pages.each_with_object([]) do |page, certifications|
      chunks = extract_chunks(page)
      last_line_before_certifications = chunks.find_index { |chunk| chunk.include?('d\'attribution') }

      next unless last_line_before_certifications

      chunks[last_line_before_certifications..].each_with_index do |chunk, index|
        code = extract_certification_code(chunk)

        next unless code

        extract_certification_information(
          certifications,
          code,
          page,
          chunks,
          last_line_before_certifications + index
        )
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def extract_certification_information(certifications, code, page, chunks, chunks_offset)
    certification = find_certification_data_from_nomenclature(code)

    chunks[chunks_offset..(chunks_offset + 4)].each do |chunk_date|
      date = extract_certification_date(chunk_date)

      next unless date

      augment_certification_payload!(certification, date, page)
      clean_same_certification_without_rge!(certifications, certification)
      certifications << certification

      break
    end
  end

  def certifications_pages
    valid_pages = pages.select do |page|
      extract_chunks(page)[0..5].any? do |chunk|
        chunk =~ /CERTIFICAT\s+QUALIBAT/i
      end
    end

    raise InvalidFile unless valid_pages.any?

    valid_pages
  end

  def find_certification_data_from_nomenclature(code)
    nomenclature_data.find { |nomenclature|
      nomenclature['code'] == code
    }.dup.symbolize_keys.except(:type)
  end

  def clean_same_certification_without_rge!(certifications, certification)
    certifications.reject! do |other_certification|
      other_certification[:code] == certification[:code] &&
        !other_certification[:rge]
    end
  end

  def augment_certification_payload!(certification, date, page)
    certification[:rge] = rge_page?(page)
    certification[:date_attribution] = Date.strptime(date[1], '%d/%m/%Y')
  end

  def rge_page?(page)
    page.text.match?(/CERTIFICAT\s+QUALIBAT.*RGE/)
  end

  def extract_certification_date(chunk)
    chunk.strip.match(%r{(\d{2}/\d{2}/\d{4})})
  end

  def extract_certification_code(chunk)
    return unless chunk.strip =~ %r{(\d{2}/\d{2}/\d{4})}

    chunk.strip.match(/^\d{2,4}/).try(:[], 0)
  end

  def nomenclature_data
    @nomenclature_data ||= JSON.parse(Rails.root.join('config/qualibat/nomenclature.json').read)
  end

  def extract_chunks(page)
    page.text.force_encoding('UTF-8').split("\n").reject(&:empty?)
  end
end
