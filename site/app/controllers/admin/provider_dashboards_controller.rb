class Admin::ProviderDashboardsController < AdminController
  include ProviderDashboardFiltering

  before_action :load_provider, except: :index
  before_action -> { build_dashboard(@provider) }, except: :index

  def index
    @providers = provider_klass.all
  end

  def show
    render 'provider/dashboard/show'
  end

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

  private

  def load_provider
    @provider = params[:id] == 'all' ? Provider::All.new(namespace) : provider_klass.find(params.expect(:id))
  end

  def provider_klass
    Kernel.const_get("API#{namespace.classify}::Provider")
  end

  def current_provider
    @provider
  end

  helper_method :current_provider
end
