class DGFIP::SVAIR::BuildResource < BuildResource
  def resource_attributes
    {
      declarant1: build_declarant(1),
      declarant2: build_declarant(2),
      foyerFiscal: {
        adresse: build_address,
        annee: extract_tax_year.to_i
      },
      dateRecouvrement: extract_info_from_table(blank_line + 1),
      dateEtablissement: extract_info_from_table(blank_line + 2),
      nombreParts: extract_info_from_table(blank_line + 3).to_f,
      situationFamille: extract_info_from_table(blank_line + 4),
      nombrePersonnesCharge: extract_info_from_table(blank_line + 5).to_i,
      revenuBrutGlobal: extract_revenu(blank_line + 6),
      revenuImposable: extract_revenu(blank_line + 7),
      impotRevenuNetAvantCorrections: extract_impot(blank_line + 8),
      montantImpot: extract_impot(blank_line + 9),
      revenuFiscalReference: extract_revenu(blank_line + 10),
      anneeImpots: extract_tax_year,
      anneeRevenus: extract_revenue_year,
      erreurCorrectif: extract_erreur_correctif,
      situationPartielle: extract_situation_partielle
    }
  end

  private

  def build_declarant(position)
    {
      nom: extract_info_from_table(2, position + 1),
      nomNaissance: extract_info_from_table(3, position + 1),
      prenoms: extract_info_from_table(4, position + 1),
      dateNaissance: extract_info_from_table(5, position + 1)
    }
  end

  def build_address
    [
      extract_address_line(1),
      extract_address_line(2),
      extract_address_line(3)
    ].compact.join(' ')
  end

  def extract_address_line(position)
    line = table.css('tr')[6 - 1 + (position - 1)]
    cell = line.css('td')[1]

    return if cell.blank?

    cell.text.strip
  end

  def extract_revenue_year
    html_nodes.css('.titre_affiche_avis').text.scan(/\d{4}/)[1]
  end

  def extract_tax_year
    html_nodes.css('.titre_affiche_avis').text.scan(/\d{4}/)[0]
  end

  def extract_revenu(line)
    revenu_raw = extract_info_from_table(line)

    return if revenu_raw == 'Non imposable'

    revenu_raw.gsub(/[^\d]/, '').to_i
  end

  def extract_impot(line)
    impot_raw = extract_info_from_table(line)

    return if impot_raw == 'Non imposable'

    impot_raw.gsub(/[^\d]/, '').to_i
  end

  def extract_info_from_table(line, column = 2)
    line = table.css('tr')[line - 1]
    cell = line.css('td')[column - 1]

    cell.text.strip
  end

  def extract_erreur_correctif
    (html_nodes.css('#erreurCorrectif').text || '').strip
  end

  def extract_situation_partielle
    (html_nodes.css('#situationPartielle').text || '').strip
  end

  def blank_line
    @blank_line ||= table.css('tr').index(table.css('tr > td.espace').first.parent) + 1
  end

  def table
    @table ||= html_nodes.css('table')
  end

  def html_nodes
    @html_nodes ||= Nokogiri.XML(response.body)
  end
end
