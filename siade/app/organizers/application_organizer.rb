class ApplicationOrganizer
  include Interactor::Organizer

  def staging?
    Rails.env.staging?
  end
end
