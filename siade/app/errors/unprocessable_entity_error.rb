class UnprocessableEntityError < ApplicationError
  attr_reader :field

  def initialize(field)
    @field = field.to_sym
  end

  # rubocop:disable Metrics/MethodLength
  def code
    {
      siren: '00301',
      siret: '00302',
      siret_or_rna: '00303',
      siret_or_eori: '00304',
      month: '00305',
      code_insee_commune: '00306',
      # DGFIP entreprise
      year: '00307',
      user_id: '00308',
      request_name: '00309',
      siren_is: '00311',
      siren_tva: '00312',
      # ACOSS
      attestation_kind: '00310',
      # ADEME
      limit: '00313',
      # CNAF
      postal_code: '00351',
      cnaf_beneficiary_number: '00352',
      # MESRI / CNOUS
      ine: '00360',
      family_name: '00361',
      first_name: '00362',
      birthday_date: '00363',
      gender: '00364',
      # DGFIP usager
      tax_number: '00370',
      tax_notice_number: '00371'
    }.fetch(field) do
      raise KeyError, "#{field} is not a valid field name"
    end
  end
  # rubocop:enable Metrics/MethodLength

  def kind
    :wrong_parameter
  end
end
