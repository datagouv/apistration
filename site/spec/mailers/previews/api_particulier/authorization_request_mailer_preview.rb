class APIParticulier::AuthorizationRequestMailerPreview < ActionMailer::Preview
  %w[
    demande_recue
    embarquement_modifications_demandees
    embarquement_demande_refusee
    demande_validee
  ].each do |method|
    define_method(method) do
      APIParticulier::AuthorizationRequestMailer.send(method, { to:, cc:, authorization_request:, update: false })
    end

    define_method("update_#{method}") do
      APIParticulier::AuthorizationRequestMailer.send(method, { to:, cc:, authorization_request:, update: true })
    end
  end

  private

  def to
    'example@fake.com'
  end

  def cc; end

  def authorization_request
    AuthorizationRequest.where(api: 'particulier').first
  end
end
