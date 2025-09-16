class ApplicationOrganizer
  include Interactor::Organizer

  def clogged_env?
    return false if ENV['SKIP_MOCKS'].present?

    Rails.env.development? || Rails.env.staging?
  end
end
