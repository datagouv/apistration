class ApplicationInteractor
  include Interactor

  protected

  def use_mocked_data?
    Rails.env.staging?
  end
end
