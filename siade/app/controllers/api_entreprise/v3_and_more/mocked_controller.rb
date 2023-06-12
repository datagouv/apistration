class APIEntreprise::V3AndMore::MockedController < APIEntreprise::V3AndMore::BaseController
  before_action :mocked_data!

  protected

  def mocked_data!
    return render not_implemented_error unless Rails.env.staging? || Rails.env.test?
  end

  def not_implemented_error
    error_json(NotImplementedYetError.new, status: :not_implemented)
  end
end
