class ApplicationOrganizer
  include Interactor::Organizer

  def clogged_env?
    Rails.env.development? || Rails.env.staging?
  end
end
