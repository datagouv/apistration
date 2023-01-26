class DGFIP::AbstractMakeRequest < MakeRequest::Get
  protected

  def params
    context.params
  end

  def user_id_sanitized
    UserIdDGFIPService.call(context.params[:user_id])
  end
end
