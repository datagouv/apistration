class QUALIBATCertificationsBatimentExtractor < PDFExtractor
  class PDFNotSupported < StandardError
    attr_reader :kind

    def initialize(kind)
      @kind = kind
      super
    end
  end

  def extract
    check_pdf_type!

    {
      date_emission:,
      date_fin_validite:,
      entity: {
        assurance_responsabilite_travaux:,
        assurance_responsabilite_civile:,
        certifications:
      }
    }
  end

  private

  def date_emission
    extract_date([
      'ÉDITÉ LE',
      'Edité le'
    ])
  end

  def date_fin_validite
    extract_date([
      'VALABLE JUSQU\'AU',
      'Valable du',
      'Validité du'
    ])
  end

  def extract_date(identifiers)
    identifiers.each do |date_identifier|
      date_chunk = first_page_chunks.find { |chunk| chunk.include?(date_identifier) }

      next if date_chunk.blank?

      raw_date = date_chunk.split.last.strip

      return Date.parse(raw_date)
    end
  end

  def assurance_responsabilite_travaux
    assurances[:assurance_responsabilite_travaux]
  end

  def assurance_responsabilite_civile
    assurances[:assurance_responsabilite_civile]
  end

  def assurances
    return @assurances if @assurances.present?

    @assurances = {}

    first_index = 0
    2.times do |i|
      if first_index.zero?
        assurance_index = first_page_chunks.index { |chunk| chunk.include?('Assurance') }
        first_index = assurance_index.dup
      else
        assurance_index = first_page_chunks[first_index + 1..].index { |chunk| chunk.include?('Assurance') } + first_index + 1
      end

      # assurance_libelle = first_page_chunks[assurance_index].strip.split(':')[0].strip

      2.times do
        assurance_index += 1
        assurance_value = first_page_chunks[assurance_index].strip.split(' ' * 10)[0].strip
        assurance_name = insurances_names.find { |insurance_name| assurance_value.include?(insurance_name) }
        if assurance_name
          kind = i.zero? ? :assurance_responsabilite_travaux : :assurance_responsabilite_civile

          @assurances[kind] = {
            nom: assurance_name,
            identifiant: assurance_value.sub("#{assurance_name} ", '')
          }
        else
          # track
        end
      end
    end

    @assurances
  end

  def certifications
    certifications = []

    extract_chunks_blocks.each do |chunks_data|
      chunks = chunks_data[:chunks]
      page = chunks_data[:page]

      last_line_before_certifications = chunks.find_index { |chunk| chunk.include?('d\'attribution') }

      chunks[last_line_before_certifications..].each_with_index do |chunk, index|
        matches = chunk.strip.match(/^\d{2,4}/)

        next unless matches

        code = matches[0]
        certification = nomenclature_data.find { |nomenclature| nomenclature['code'] == code }.dup
        certification['code'] = certification['code'].to_s

        next unless certification

        certification['rge'] = pages[page - 1].text.match?(/CERTIFICAT\s+QUALIBAT.*RGE/)

        chunks[last_line_before_certifications + index..last_line_before_certifications + index + 4].each do |chunk_date|
          date = chunk_date.strip.match(%r{(\d{2}/\d{2}/\d{4})})

          next unless date

          certification['date_attribution'] = Date.strptime(date[1], '%d/%m/%Y')

          certifications.reject! { |other_certification| other_certification['code'] == certification['code'] && certification['rge'] }
          certifications << certification.except('type')
          break
        end
      end
    end

    certifications.map(&:symbolize_keys)
  end

  def extract_chunks_blocks
    if simple_certificate? || certificates_with_annexes?
      [{
        chunks: first_page_chunks,
        page: 1
      }]
    elsif with_rge_only?
      [{
        chunks: extract_chunks(pages[1]),
        page: 2
      }]
    elsif with_and_without_rge_on_second_page?
      [{
        chunks: first_page_chunks,
        page: 1
      },
       {
         chunks: extract_chunks(pages[1]),
         page: 2
       }]
    elsif with_and_without_rge_on_third_page?
      [{
        chunks: first_page_chunks,
        page: 1
      },
       {
         chunks: extract_chunks(pages[2]),
         page: 3
       }]
    else
      raise InvalidFile
    end
  end

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

  def check_pdf_type!
    raise PDFNotSupported, :amiante if pages.first.text.include?('TRAITEMENT DE L\'AMIANTE')
    raise PDFNotSupported, :permeabilite_air if pages.first.text.include?('MESURES DE LA PERMÉABILITE A L\'AIR')
  end

  def pages
    @pages ||= pdf_reader.pages
  end

  def first_page_chunks
    @first_page_chunks ||= extract_chunks(pages.first)
  end

  def extract_chunks(page)
    page.text.force_encoding('UTF-8').split("\n").reject(&:empty?)
  end

  def nomenclature_data
    @nomenclature_data ||= JSON.parse(Rails.root.join('config/qualibat/nomenclature.json').read)
  end

  def insurances_names
    Rails.application.config_for('qualibat/insurance_names')
  end
end
