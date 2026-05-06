class Provider::DashboardController < ProviderController
  include ProviderDashboardFiltering

  before_action :user_is_provider?, only: :index
  before_action :user_is_current_provider?, except: :index
  before_action -> { build_dashboard(current_provider) }, except: :index

  def index
    @providers = provider_klass.filter_by_uid(current_user.provider_uids)

    return unless @providers.size == 1

    redirect_to provider_dashboard_path(provider_uid: @providers.first.uid)
  end

  def show; end

  def global_section        = render_section(:global)
  def success_section       = render_section(:success)
  def duration_section      = render_section(:duration)
  def consumers_section     = render_section(:consumers)
  def habilitations_section = render_section(:habilitations)

  def consumers_export
    formatter = Provider::ConsumersCsvFormatter.new(@query.consumers_rows)
    send_data formatter.to_csv, filename: formatter.filename, type: 'text/csv; charset=utf-8'
  end

  def habilitations_export
    formatter = Provider::HabilitationsCsvFormatter.new(@query.habilitations_rows)
    send_data formatter.to_csv, filename: formatter.filename, type: 'text/csv; charset=utf-8'
  end
end
