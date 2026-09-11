class AttestationPDFBuilder
  BOLD = ['Helvetica', { variant: :bold }].freeze

  QR_SIZE = 140
  MARGIN = 40
  SECTION_HEADER_HEIGHT = 40

  def initialize(payload:, visual_code:, verification_url:, test: false)
    @payload = payload
    @sections = payload.fetch('sections')
    @siret = payload['siret']
    @habilitation = payload['habilitation']
    @emise_le = payload['emise_le']
    @visual_code = visual_code
    @verification_url = verification_url
    @test = test
  end

  def render
    compose_header
    compose_sections
    draw_qr_code

    io = StringIO.new(''.b)
    composer.document.write(io)
    io.string
  end

  private

  def composer
    @composer ||= HexaPDF::Composer.new(page_size: :A4, margin: [MARGIN, MARGIN, QR_SIZE + 80, MARGIN]).tap do |composer|
      composer.style(:base, font: 'Helvetica', font_size: 10, line_spacing: 1.3)
      composer.style(:header, font: BOLD, font_size: 13)
      composer.style(:muted, font: 'Helvetica', fill_color: '666666', font_size: 9)
      composer.style(:title, font: BOLD, font_size: 16, margin: [24, 0, 4, 0], text_align: :center)
      composer.style(:subtitle, font: 'Helvetica', fill_color: '666666', font_size: 9, margin: [0, 0, 8, 0], text_align: :center)
      composer.style(:banner, font: BOLD, font_size: 12, fill_color: 'C9191E', margin: [8, 0, 8, 0], text_align: :center)
      composer.style(:code, font: BOLD, font_size: 14, margin: [8, 0, 8, 0], text_align: :center)
      composer.style(:section, font: BOLD, font_size: 11, fill_color: '000091', margin: [12, 0, 3, 0])
      composer.style(:label, font: BOLD, font_size: 10)
      composer.style(:highlight, font: BOLD, font_size: 13, fill_color: '000091')
    end
  end

  def compose_header
    composer.text("RÉPUBLIQUE\nFRANÇAISE", style: :header, position: :float)
    composer.text("API Particulier\nparticulier.api.gouv.fr\nSource : #{@payload.fetch('source')}", style: :muted, text_align: :right)
    rule(color: 'DDDDDD', margin: [10, 0, 0, 0])
    composer.text(@payload.fetch('titre'), style: :title)
    composer.text("Document délivré le #{format_date(@emise_le)} — à valeur justificative", style: :subtitle)
    composer.text('DONNÉES DE TEST — DOCUMENT SANS VALEUR', style: :banner) if @test
    composer.text("Code de vérification : #{@visual_code}", style: :code)
  end

  def compose_sections
    @sections.each do |section|
      entry_rows = section.fetch('entrees')

      break_page_unless_room_for(entry_rows)
      composer.text(section.fetch('titre').upcase, style: :section)
      rule(color: '000091', height: 2, margin: [0, 0, 8, 0])
      entry_rows.each { |rows| compose_entry(rows) }
    end
  end

  def break_page_unless_room_for(entry_rows)
    height = SECTION_HEADER_HEIGHT + entry_rows.sum { |rows| measure_entry(rows) + 8 }
    available = composer.frame.available_height

    composer.new_page if height > available && available < composer.frame.height
  end

  def measure_entry(rows)
    box = composer.document.layout.table_box(build_cells(rows), column_widths: [190, -1],
      cell_style: { border: { width: 0 }, padding: [2, 0] })
    box.fit(composer.frame.available_width, 10_000, composer.frame)
    box.height
  end

  def compose_entry(rows)
    composer.table(build_cells(rows), column_widths: [190, -1],
      style: { margin: [0, 0, 8, 0] },
      cell_style: { border: { width: 0 }, padding: [2, 0] })
  end

  def build_cells(rows)
    rows.map do |label, value|
      [
        composer.document.layout.text_box(label, style: :label),
        value.is_a?(Hash) ? composer.document.layout.text_box(value.fetch('highlight'), style: :highlight) : value
      ]
    end
  end

  def rule(color:, height: 1, margin: [0, 0, 0, 0])
    composer.box(:base, height:, style: { background_color: color, margin: })
  end

  def format_date(value)
    Date.parse(value).strftime('%d/%m/%Y')
  end

  def draw_qr_code
    canvas = composer.canvas
    modules = RQRCodeCore::QRCode.new(@verification_url, level: :m).modules
    module_size = QR_SIZE.to_f / modules.size

    canvas.fill_color('000000')
    modules.each_with_index do |row, row_index|
      draw_qr_row(canvas, row, row_index, module_size)
    end
    canvas.fill

    draw_footer(canvas)
  end

  def draw_qr_row(canvas, row, row_index, module_size)
    dark_runs(row).each do |run|
      canvas.rectangle(MARGIN + (run.first * module_size),
        MARGIN + QR_SIZE - ((row_index + 1) * module_size),
        run.size * module_size, module_size)
    end
  end

  def dark_runs(row)
    row.each_index.slice_when { |left, right| row[left] != row[right] }
      .select { |run| row[run.first] }
  end

  def draw_footer(canvas)
    left = MARGIN + QR_SIZE + 12

    draw_footer_frame(canvas)
    draw_verification_instructions(canvas, left)
    draw_code_box(canvas, left)
    add_verification_link_annotation

    canvas.font('Helvetica', size: 8)
    canvas.fill_color('888888')
    canvas.text("Émis pour le compte du SIRET #{@siret}#{" (habilitation #{@habilitation})" if @habilitation}, le #{format_date(@emise_le)}.", at: [left, MARGIN + 8])
  end

  def draw_footer_frame(canvas)
    canvas.fill_color('DDDDDD')
    canvas.rectangle(MARGIN, MARGIN + QR_SIZE + 20, 515, 1).fill

    canvas.stroke_color('DDDDDD')
    canvas.rectangle(MARGIN - 1, MARGIN - 1, QR_SIZE + 2, QR_SIZE + 2).stroke
  end

  def draw_verification_instructions(canvas, left)
    canvas.font('Helvetica', size: 10, variant: :bold)
    canvas.fill_color('161616')
    canvas.text("Vérifier l'authenticité de ce document", at: [left, MARGIN + QR_SIZE - 12])

    canvas.font('Helvetica', size: 9)
    canvas.fill_color('333333')
    canvas.text('Scannez le QR code ci-contre ou cliquez ici pour ouvrir la page de', at: [left, MARGIN + QR_SIZE - 28])
    canvas.text('vérification sur particulier.api.gouv.fr, puis comparez le code', at: [left, MARGIN + QR_SIZE - 40])
    canvas.text('ci-dessous avec celui affiché sur la page.', at: [left, MARGIN + QR_SIZE - 52])
  end

  def add_verification_link_annotation
    annotations = composer.page[:Annots] ||= []
    annotations << composer.document.add(
      { Type: :Annot, Subtype: :Link, Border: [0, 0, 0],
        Rect: [MARGIN - 1, MARGIN - 1, MARGIN + 515, MARGIN + QR_SIZE + 1],
        A: { Type: :Action, S: :URI, URI: @verification_url } }
    )
  end

  def draw_code_box(canvas, left)
    baseline = MARGIN + QR_SIZE - 84

    canvas.stroke_color('999999')
    canvas.line_dash_pattern([3, 2])
    canvas.rectangle(left, baseline - 7, 104, 24).stroke
    canvas.line_dash_pattern(0)

    canvas.font('Helvetica', size: 13, variant: :bold)
    canvas.fill_color('161616')
    canvas.text(@visual_code, at: [left + 8, baseline])
  end
end
