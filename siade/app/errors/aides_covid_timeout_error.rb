class AidesCovidTimeoutError < ApplicationError
  def code
    '00002'
  end

  def title
    'Intermédiaire hors-délai'
  end

  def detail
    "Le service intermédiaire n'a pas répondu"
  end

  def meta
    {
      retry_in: 1000,
      provider: errors_backend.provider_from_code(code),
    }
  end

  def kind
    :provider_error
  end
end
