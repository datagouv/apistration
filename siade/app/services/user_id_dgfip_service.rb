class UserIdDGFIPService
  def self.call(user_id)
    user_id.to_s.
      gsub('.','_').
      gsub('@','_at_').
      gsub('-','_')
  end
end
