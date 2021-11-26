class DGFIP::ValidateUserId < ValidateParamInteractor
  def call
    return if user_id_is_an_uuid?

    invalid_param!(:user_id)
  end

  private

  def user_id_is_an_uuid?
    param(:user_id).present? &&
      param(:user_id) =~ v4_uuid_regex
  end

  # https://rubular.com/r/0L7Icy8rIPHna7
  def v4_uuid_regex
    /\A[\da-f]{8}-(?:[\da-f]{4}-){3}[\da-f]{12}\z/i
  end
end
