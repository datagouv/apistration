class ValidateYear < ValidateParamInteractor
  include YearValidation

  raises UnprocessableEntityError, field: :year
end
