class MaintenanceError < AbstractGenericProviderError
  def subcode
    '020'
  end

  def detail
    if maintenance_on?
      "Le fournisseur de données est en maintenance de #{format_hour(maintenance_service.from_hour)} à #{format_hour(maintenance_service.to_hour)}"
    else
      'Le fournisseur de données semble être en maintenance'
    end
  end

  def extra_meta
    if maintenance_on?
      {
        retry_in: maintenance_service.remaining_seconds
      }
    else
      super
    end
  end

  private

  def maintenance_on?
    maintenance_service.on?
  end

  def format_hour(time)
    time.strftime('%H:%M')
  end

  def maintenance_service
    @maintenance_service ||= MaintenanceService.new(provider_name)
  end
end
