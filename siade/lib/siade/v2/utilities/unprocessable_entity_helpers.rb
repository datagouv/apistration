module SIADE::V2::Utilities::UnprocessableEntityHelpers
  protected

  def set_error_for_bad_siret
    set_error_for_bad(:siret)
  end

  def set_error_for_bad_siren
    set_error_for_bad(:siren)
  end

  def set_error_for_bad(kind)
    (@errors ||= []) << UnprocessableEntityError.new(kind)
  end
end
