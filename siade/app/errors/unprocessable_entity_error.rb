class UnprocessableEntityError < ApplicationError
  attr_reader :field

  def initialize(field)
    @field = field.to_sym
  end

  def code
    {
      siren: '00301',
      siret: '00302',
      siret_or_rna: '00303',
      siret_or_eori: '00304',
      month: '00305',
      code_insee_commune: '00306',
      # DGFIP
      year: '00307',
      user_id: '00308',
      request_name: '00309',
      siren_is: '00311',
      siren_tva: '00312',
      # ACOSS
      attestation_kind: '00310'
    }.fetch(field) do
      raise KeyError, "#{field} is not a valid field name"
    end
  end

  def kind
    :wrong_parameter
  end
end
