class DGFIP::DerniereSituationIR::BuildResource < BuildResource
  protected

  DATE_FORMAT = '%d/%m/%Y'.freeze
  SITUATIONS_DE_FAMILLE = {
    'M' => 'Marié(e)s',
    'C' => 'Célibataire',
    'D' => 'Divorcé(e)',
    'V' => 'Veuf(ve)',
    'O' => 'Pacsé(e)s'
  }.freeze

  def resource_attributes
    {
      declarant1: {
        nom: json_body['nmUsaDec1'],
        nomNaissance: json_body['nmNaiDec1'],
        prenoms: json_body['prnmDec1'],
        dateNaissance: date_naissance_declarant_1
      },
      declarant2: {
        nom: json_body['nmUsaDec2'] || '',
        nomNaissance: json_body['nmNaiDec2'] || '',
        prenoms: json_body['prnmDec2'] || '',
        dateNaissance: date_naissance_declarant_2 || ''
      },
      foyerFiscal: {
        adresse: json_body['aft'].try(:strip) || '',
        annee: annee_impots.to_i
      },
      dateRecouvrement: date_recouvrement,
      dateEtablissement: date_etablissement,
      nombreParts: json_body['nbPart'],
      situationFamille: situation_famille,
      nombrePersonnesCharge: json_body.dig('pac', 'nbPac'),
      revenuBrutGlobal: json_body['revenuBrutGlobal'],
      revenuImposable: json_body['revImposable'],
      impotRevenuNetAvantCorrections: positive_or_nil(json_body['impAvImput']),
      montantImpot: positive_or_nil(json_body['montTotIr']),
      revenuFiscalReference: json_body['rfr'],
      anneeImpots: annee_impots.to_s,
      anneeRevenus: json_body['annRevenu'].to_s,
      erreurCorrectif: '',
      situationPartielle: ''
    }
  end

  private

  def positive_or_nil(value)
    value.positive? ? value : nil
  end

  def date_naissance_declarant_1
    [
      json_body.dig('dateNaisDec1', 'jour'),
      json_body.dig('dateNaisDec1', 'mois'),
      json_body.dig('dateNaisDec1', 'annee')
    ].join('/')
  end

  def date_naissance_declarant_2
    return '' if json_body['dateNaisDec2']['annee'].nil?

    [
      json_body.dig('dateNaisDec2', 'jour'),
      json_body.dig('dateNaisDec2', 'mois'),
      json_body.dig('dateNaisDec2', 'annee')
    ].join('/')
  end

  def date_recouvrement
    Date
      .parse(json_body['datRec'])
      .strftime(DATE_FORMAT)
  end

  def date_etablissement
    Date
      .parse(json_body['datEtab'])
      .strftime(DATE_FORMAT)
  end

  def situation_famille
    SITUATIONS_DE_FAMILLE[json_body['sitFam']]
  end

  def annee_impots
    json_body['annRevenu'] + 1
  end
end
