module SIADE::V3::Referentials::DeprecatedDataTrackable
  protected

  def track_deprecated_data(field, deprecated_data)
    MonitoringService.instance.track_deprecated_data(
      field,
      deprecated_data,
    )
  end
end
