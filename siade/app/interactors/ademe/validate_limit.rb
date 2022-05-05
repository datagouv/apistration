class ADEME::ValidateLimit < ValidateParamInteractor
  def call
    return if limit.between?(1, 1_000)

    invalid_param!(:limit)
  end

  private

  def limit
    context.params[:limit].to_i
  end
end
