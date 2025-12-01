class GIPMDS::Effectifs::BuildResource < BuildResource
  protected

  def cleaned_effectifs
    @cleaned_effectifs ||= json_body.map do |effectif|
      base_data = {
        regime: extract_regime_from_effectif(effectif),
        nature: extract_nature_from_effectif(effectif),
        year: effectif['periode'].first(4),
        month: effectif['periode'][4..5]
      }

      if effectif['effectifs'] == 'NC'
        base_data.merge({
          value: nil,
          date_derniere_mise_a_jour: nil
        })
      else
        base_data.merge({
          value: effectif['effectifs'].to_f,
          date_derniere_mise_a_jour: build_date(effectif['miseAJourRCD'])
        })
      end
    end
  end

  private

  def extract_regime_from_effectif(effectif)
    case effectif['source']
    when 'RA'
      'regime_agricole'
    when 'RG'
      'regime_general'
    else
      raise "Unknown source #{effectif['source']}"
    end
  end

  def extract_nature_from_effectif(effectif) # rubocop:disable Metrics/CyclomaticComplexity
    case effectif['nature']
    when 'A01' then 'effectif_moyen_annuel'
    when 'A02' then 'effectif_boeth_annuel'
    when 'A03' then 'effectif_ecap_annuel'
    when 'A04' then 'effectif_assujettissement_oeth_annuel'
    when 'M01' then 'effectif_moyen_mensuel'
    when 'M02' then 'effectif_boeth_mensuel'
    when 'M03' then 'effectif_ecap_mensuel'
    when 'M04' then 'effectif_assujettissement_oeth_mensuel'
    else
      raise "Unknown type #{effectif['nature']}"
    end
  end

  def build_date(date)
    return nil if date.blank?

    Date.parse(date)
  end
end
