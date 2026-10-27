module Admin::StatisticsHelper
  BUCKET_FORMATS = {
    'jour' => '%d/%m/%Y',
    'semaine' => 'S%V %G',
    'mois' => '%m/%Y'
  }.freeze

  def bucket_label(date, interval = 'mois')
    date.strftime(BUCKET_FORMATS.fetch(interval, '%d/%m/%Y'))
  end

  def variation_label(current, previous)
    return 'Aucun appel sur la période précédente' if previous.zero?

    variation = ((current - previous) * 100.0 / previous).round(1)
    "#{format('%+.1f', variation)} % vs période précédente (#{number_with_delimiter(previous)})"
  end

  def datapass_link(external_id, api)
    return external_id if external_id.blank? || api.blank?

    external_link_to(external_id, "#{datapass_base_url}/api-#{api}/#{external_id}")
  end

  def statistics_lazy_section(page, section, label:, **filter)
    filter_params = request.query_parameters.fetch('filter', {}).to_h.merge(filter.stringify_keys)

    turbo_frame_tag(statistics_frame_id(section, filter[:domaine]), src: section_admin_statistic_path(page:, section:, filter: filter_params), loading: :lazy) do
      render('provider/dashboard/loading', section: label)
    end
  end

  def statistics_frame_id(section, domaine = nil)
    [section, domaine].compact.join('_')
  end

  def statistics_controller_options(filter)
    scope = ControllerName.all
    scope = scope.where("split_part(controller, '/', 1) = ?", filter.domaine_prefix) if filter.domaine?
    (scope.order(:controller).pluck(:controller) | [filter.api]).compact
  end

  def statistics_demarche_options(filter)
    scope = AuthorizationRequest.joins(:tokens).where.not(demarche: [nil, ''])
    scope = scope.where(api: filter.domaine) if filter.domaine?
    scope
      .group(:demarche)
      .order(:demarche)
      .count('DISTINCT authorization_requests.id')
      .map { |demarche, count| ["#{demarche} (#{count})", demarche] }
  end

  def statistics_status_options
    AuthorizationRequest.distinct.order(:status).pluck(:status).compact
  end
end
