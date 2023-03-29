class GIPMDS::Effectifs::BuildResource < BuildResource
  protected

  def annee
    json_body
      .first['periode']
      .first(4)
  end

  def regime_general
    build_effectifs_annuel_for('RG')
  end

  def regime_agricole
    build_effectifs_annuel_for('RA')
  end

  def build_effectifs_annuel_for(regime)
    valid_payload = json_body.find { |effectif_annuel| effectif_annuel['source'] == regime }

    if valid_payload['effectifs'] == 'NC'
      {
        value: nil,
        date_derniere_mise_a_jour: nil
      }
    else
      {
        value: valid_payload['effectifs'].to_f,
        date_derniere_mise_a_jour: build_date(valid_payload['miseAjourRCD'])
      }
    end
  end

  def build_date(date)
    return nil if date.blank?

    Date.parse(date)
  end
end
