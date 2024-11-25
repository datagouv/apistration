class ConflictError < ApplicationError
  def code
    '00015'
  end

  def detail
    'Une requête associé à votre jeton est déjà en cours de traitement pour ces paramètres. Veuillez attendre la fin du traitement avant d\'effectuer une nouvelle requête.'
  end

  def kind
    :conflict
  end
end
