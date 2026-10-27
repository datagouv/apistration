module FeatureHelper
  include ActionView::RecordIdentifier
  include ActionView::Helpers::DateHelper

  def login_as(user, siret: nil)
    page.set_rack_session(
      current_user_id: user.id,
      current_user_siret: siret,
      last_seen_at: Time.current.to_i,
      absolute_expires_at: 24.hours.from_now.to_i
    )
  end

  def logout
    page.set_rack_session(current_user_id: nil)
  end
end
