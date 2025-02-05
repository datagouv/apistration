class QUALIBAT::CertificationsBatiment::ValidateResponse < ValidateResponse
  def call
    internal_server_error! if http_internal_error?
    resource_not_found! if http_not_found? || json_has_errors?

    if empty_body? && http_ok?
      track_empty_file_error
      empty_file_error!
    end

    return if http_ok?

    unknown_provider_response!
  end

  private

  def empty_file_error!
    fail_with_error!(BadFileFromProviderError.new(context.provider_name, :empty_file, 'Le fichier renvoyé par le fournisseur de données est vide, le fournisseur de données sera notifié de l\'erreur pour correction'))
  end

  def track_empty_file_error
    MonitoringService.instance.track(
      'info',
      'Qualibat: empty file'
    )
  end

  def empty_body?
    body.empty?
  end

  def json_has_errors?
    json_valid? && json_body['status_code'] == 404
  end

  def json_valid?
    !invalid_json?
  end
end
