class URSSAFAttestationVigilanceExtractor < PDFExtractor
  class InvalidAttestationVigilance < InvalidFile; end

  def extract
    {
      code_securite:,
      date_debut_validite:
    }
  end

  private

  def code_securite
    pages[0].text.split("\n").map(&:strip).find do |word|
      word =~ /^([A-Z0-9]{15})$/
    end || raise_invalid_attestation_vigilance
  end

  def date_debut_validite
    date = date_debut_validite_from_main_case ||
           date_debut_validite_from_micro_entreprise_liberal ||
           raise_invalid_attestation_vigilance

    Date.parse(date)
  end

  def date_debut_validite_from_main_case
    extract_from_page(pages[1], 'à la date du (\d{2}\/\d{2}\/\d{4})')
  end

  def date_debut_validite_from_micro_entreprise_liberal
    extract_from_page(pages[1], 'professionnelle - CFP\) (?:exigibles )?au (\d{2}\/\d{2}\/\d{4})')
  end

  def extract_from_page(page, to_match)
    date_matches = page.text.match(to_match)
    return date_matches[1] if date_matches
  end

  def raise_invalid_attestation_vigilance
    raise InvalidAttestationVigilance
  end

  def pages
    pdf_reader.pages
  end
end
