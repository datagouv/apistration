class ApplicationInteractor
  include Interactor

  protected

  def use_mocked_data?
    return false if ENV['SKIP_MOCKS'].present?

    Rails.env.staging? ||
      Rails.env.development?
  end
end
