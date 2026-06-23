module CasUsagesManagement
  def index
    @fiches_pratiques = fiche_pratique_klass.all
    @cas_usages = cas_usage_klass.all
  end

  def show
    @fiche_pratique = fiche_pratique_klass.find(params.expect(:uid))
    @other_fiches_pratiques = fiche_pratique_klass.all - [@fiche_pratique]
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  private

  def fiche_pratique_klass
    namespace.classify.constantize::FichePratique
  end

  def cas_usage_klass
    namespace.classify.constantize::CasUsage
  end
end
