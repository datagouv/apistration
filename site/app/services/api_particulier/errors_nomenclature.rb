class APIParticulier::ErrorsNomenclature < AbstractErrorsNomenclature
  protected

  def local_path
    Rails.root.join('config/errors_particulier.yml')
  end
end
