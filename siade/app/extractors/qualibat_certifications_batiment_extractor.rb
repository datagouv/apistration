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

  def assurance_responsabilite_travaux
    assurances[:assurance_responsabilite_travaux]
  end

  def assurance_responsabilite_civile
    assurances[:assurance_responsabilite_civile]
  end

  def certifications
    @certifications ||= QUALIBATCertificationsBatiment::CertificationsExtractor.initialize_with_reader(pdf_reader).perform
  end

  def extract_date(identifiers)
    identifiers.each do |date_identifier|
      date_chunk = first_page_chunks.find { |chunk| chunk.include?(date_identifier) }

      next if date_chunk.blank?

      raw_date = date_chunk.split.last.strip

      return Date.parse(raw_date)
    end
  end

  def assurances
    @assurances ||= QUALIBATCertificationsBatiment::InsurancesExtractor.initialize_with_reader(pdf_reader).perform
  end

  def check_pdf_type!
    {
      amiante: 'TRAITEMENT DE L\'AMIANTE',
      permeabilite_air: 'MESURES DE LA PERMÉABILITE A L\'AIR',
      metallerie_feu: 'MÉTALLERIE FEU',
      reseaux_aerauliques: 'RÉSEAUX AÉRAULIQUES',
      traitement_bois: 'TRAITEMENT DES BOIS',
      cordistes: 'CORDISTES',
      verification_mesures_systemes_ventilation: 'VÉRIFICATIONS ET MESURES DES SYSTÈMES DE VENTILATION'
    }.each do |kind, identifier|
      raise PDFNotSupported, kind if pages.first.text.include?(identifier)
    end
  end

  def first_page_chunks
    @first_page_chunks ||= pages[0].text.force_encoding('UTF-8').split("\n").reject(&:empty?)
  end
end
