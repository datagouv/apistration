class APIEntreprise::AuthorizationRequestMailerPreview < ActionMailer::Preview
  %w[
    demande_recue
    embarquement_modifications_demandees
    embarquement_demande_refusee
    demande_validee
  ].each do |method|
    define_method(method) do
      APIEntreprise::AuthorizationRequestMailer.send(method, { to:, cc:, authorization_request:, update: false })
    end

    define_method("update_#{method}") do
      APIEntreprise::AuthorizationRequestMailer.send(method, { to:, cc:, authorization_request:, update: true })
    end
  end

  def jeton_disponible
    APIEntreprise::AuthorizationRequestMailer.jeton_disponible({ to:, cc:, authorization_request: })
  end

  private

  def to
    'example@fake.com'
  end

  def cc; end

  def authorization_request
    AuthorizationRequest.with_tokens_for('entreprise').first
  end
end
