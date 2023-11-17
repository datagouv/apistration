class QUALIBATCertificationsBatiment::CertificationsExtractor < PDFExtractor
  def extract
    certifications
  end

  private

  def certifications
    certifications_pages.each_with_object([]) do |page, certifications|
      chunks = extract_chunks(page)
      last_line_before_certifications = chunks.find_index { |chunk| chunk.include?('d\'attribution') }

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

  def extract_certification_information(certifications, code, page, chunks, chunks_offset)
    certification = find_certification_data_from_nomenclature(code)

    chunks[chunks_offset..chunks_offset + 4].each do |chunk_date|
      date = extract_certification_date(chunk_date)

      next unless date

      augment_certification_payload!(certification, date, page)
      clean_same_certification_without_rge!(certifications, certification)
      certifications << certification

      break
    end
  end

  # rubocop:disable Metrics/AbcSize
  def certifications_pages
    if simple_certificate? || certificates_with_annexes?
      [pages[0]]
    elsif with_rge_only?
      [pages[1]]
    elsif with_and_without_rge_on_second_page?
      [pages[0], pages[1]]
    elsif with_and_without_rge_on_third_page?
      [pages[0], pages[2]]
    else
      raise InvalidFile
    end
  end
  # rubocop:enable Metrics/AbcSize

  def with_rge_only?
    pages[0].text.include?('Cette entreprise est qualifiée, consultez le certificat RGE')
  end

  def with_and_without_rge_on_second_page?
    pages.count > 1 && pages[1].text.match?(/CERTIFICAT\s+QUALIBAT.*RGE/)
  end

  def with_and_without_rge_on_third_page?
    pages.count > 2 && pages[2].text.match?(/CERTIFICAT\s+QUALIBAT.*RGE/)
  end

  def simple_certificate?
    pages.count == 1
  end

  def certificates_with_annexes?
    pages.count > 1 && (
      pages[1].text.include?('ANNEXE CERTIFICAT') ||
        pages[1].text.include?('ANNEXE AU CERTIFICAT')
    )
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
    chunk.strip.match(/^\d{2,4}/).try(:[], 0)
  end

  def nomenclature_data
    @nomenclature_data ||= JSON.parse(Rails.root.join('config/qualibat/nomenclature.json').read)
  end

  def extract_chunks(page)
    page.text.force_encoding('UTF-8').split("\n").reject(&:empty?)
  end
end
