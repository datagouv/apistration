class DGFIP::TVA::SelectTVANumber < ApplicationInteractor
  def call
    return if use_mocked_data?

    context.numero_tva = "FR#{selected_vat_no}"
  end

  private

  def selected_vat_no
    return computed_vat_no if found_vat_nos.include?(computed_vat_no)

    most_recently_issued_row['vat_no']
  end

  def most_recently_issued_row
    rows.max_by { |row| [row['issued_date'].to_s, row['vat_no']] }
  end

  def found_vat_nos
    rows.pluck('vat_no')
  end

  def computed_vat_no
    context.tva_number[2..]
  end

  def rows
    @rows ||= JSON.parse(context.response.body)['data']
  end
end
