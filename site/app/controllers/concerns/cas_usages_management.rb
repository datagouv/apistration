module CasUsagesManagement
  def index
    @cas_usages = cas_usage_klass.all
    @simplifions_use_cases = SimplifionsStore.all_use_cases(api: namespace)
  end

  def show
    @cas_usage = cas_usage_klass.find(params.expect(:uid))
    @other_cas_usages = cas_usage_klass.all - [@cas_usage]
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  private

  def cas_usage_klass
    namespace.classify.constantize::CasUsage
  end
end
