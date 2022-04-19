class DGFIP::LiassesFiscales::Declarations::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      obligations_fiscales: build_obligations_fiscales,
      declarations: declarations_attributes.map { |declaration_attributes| build_declaration(declaration_attributes) },
      internal_id_itip: entreprise_attributes['itip']
    }
  end

  private

  def build_declaration(declaration_attributes)
    {
      numero_imprime: declaration_attributes['numero_imprime'],
      regime: build_regime_from_declaration(declaration_attributes),
      date_declaration: declaration_attributes['date_declaration'],
      date_fin_exercice: declaration_attributes['fin_exercice'],
      duree_exercice: declaration_attributes['duree_exercice'].to_i,
      millesime: declaration_attributes['millesime'],
      donnees: build_data_from_declaration(declaration_attributes)
    }
  end

  def build_obligations_fiscales
    Array.wrap(entreprise_attributes['setOcfis']).map do |obligation_fiscale|
      {
        id: obligation_fiscale['numOcfi'],
        code: obligation_fiscale['codeObf'],
        libelle: obligations_fiscales_code_to_libelle[obligation_fiscale['codeObf']],
        reference: obligation_fiscale['ROF'],
        regime: obligation_fiscale['regime']
      }
    end
  end

  def build_regime_from_declaration(declaration_attributes)
    {
      code: declaration_attributes['code_regime'],
      libelle: regime_imposition_code_to_libelle[declaration_attributes['code_regime']]
    }
  end

  def build_data_from_declaration(declaration_attributes)
    Array.wrap(declaration_attributes['imprime']['donnees']).map do |datum|
      {
        code_nref: datum['code_nref'],
        valeurs: aggregate_data_for_code_nref(datum['code_nref'], declaration_attributes['imprime']['donnees'])
      }
    end
  end

  def aggregate_data_for_code_nref(code_nref, declaration_donnees_attributes)
    case declaration_donnees_attributes
    when Hash
      [declaration_donnees_attributes['valeur']]
    when Array
      code_nref_data = declaration_donnees_attributes.select do |declaration_donnee_attributes|
        declaration_donnee_attributes['code_nref'] == code_nref
      end

      if code_nref_data.one?
        extract_single_value_from_declaration(code_nref_data.first)
      else
        extract_multiple_values_from_declaration(code_nref_data)
      end
    else
      raise 'Something went wrong'
    end
  end

  def extract_single_value_from_declaration(code_nref_datum)
    [
      code_nref_datum['valeur'] ||
        code_nref_datum['valeurs']['valeur']
    ]
  end

  def extract_multiple_values_from_declaration(code_nref_data)
    sorted_code_nref_data = code_nref_data.sort do |datum_1, datum_2|
      datum_2['indiceRepetition'].to_i <=> datum_1['indiceRepetition'].to_i
    end

    sorted_code_nref_data.map do |datum|
      datum['valeurs']['valeur']
    end
  end

  def declarations_attributes
    @declarations_attributes ||= json_body['declarations']
  end

  def entreprise_attributes
    @entreprise_attributes ||= json_body['entreprise']
  end

  def json_body
    @json_body ||= JSON.parse(response.body)
  end

  def obligations_fiscales_code_to_libelle
    {
      'IS' => 'Impôt sur les sociétés',
      'BIC' => 'Bénéfices industriels et commerciaux',
      'IS GROUPE' => 'Impôt sur les sociétés dû par le groupe',
      'BA' => 'Bénéfices agricoles',
      'BNC' => 'Bénéfices non commerciaux'
    }
  end

  def regime_imposition_code_to_libelle
    {
      'RN' => 'Réel normal',
      'RS' => 'Régime simplifié',
      'RSI' => 'Régime simplifié',
      'RNMEMBRE' => 'Réel normal groupe (groupe)',
      'RNGROUPE' => 'Réel normal groupe (tête)',
      'DECC' => 'Déclaration contrôlée'
    }
  end
end
