class MaintenanceError < AbstractGenericProviderError
  def subcode
    '020'
  end

  def detail
    "Le fournisseur de données est en maintenance de #{format_hour(maintenance_service.from_hour)} à #{format_hour(maintenance_service.to_hour)}"
  end

  def extra_meta
    {
      retry_in: maintenance_service.remaining_seconds
    }
  end

  private

  def format_hour(time)
    time.strftime('%H:%M')
  end

  def maintenance_service
    @maintenance_service ||= MaintenanceService.new(provider_name)
  end
end
