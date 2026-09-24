class APIEntreprise::ErrorsNomenclature < AbstractErrorsNomenclature
  protected

  def local_path
    Rails.root.join('config/errors_entreprise.yml')
  end
end
