class ApplicationInteractor
  include Interactor

  def use_mocked_data?
    Rails.env.staging?
  end
end
