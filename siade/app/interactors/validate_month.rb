class ValidateMonth < ValidateParamInteractor
  include MonthValidation

  raises UnprocessableEntityError, field: :month
end
