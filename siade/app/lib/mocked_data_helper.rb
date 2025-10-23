module MockedDataHelper
  def use_mocked_data?
    return false if ENV['SKIP_MOCKS'].present?

    Rails.env.development? || Rails.env.staging?
  end
end
