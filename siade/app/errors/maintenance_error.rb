class MaintenanceError < AbstractGenericProviderError
  def self.build_example(provider_name:, **)
    new(provider_name, live_schedule: false)
  end

  def initialize(provider_name, message = nil, live_schedule: true)
    super(provider_name, message)

    @live_schedule = live_schedule
  end

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

  def kind
    :maintenance
  end

  private

  def maintenance_on?
    @live_schedule && maintenance_service.on?
  end

  def format_hour(time)
    time.strftime('%H:%M')
  end

  def maintenance_service
    @maintenance_service ||= MaintenanceService.new(provider_name)
  end
end
