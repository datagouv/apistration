return if Rails.env.production?

class Token
  def readonly?
    false
  end
end

Seeds.new.perform
