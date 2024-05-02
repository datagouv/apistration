class ApplicationOrganizer
  include Interactor::Organizer

  def staging?
    Rails.env.staging? || Rails.env.development?
  end
end
