class ApplicationInteractor
  include Interactor

  def staging?
    Rails.env.staging?
  end
end
