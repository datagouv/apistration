class INPI::ValidateLimit < ValidateParamInteractor
  def call
    return if limit.between?(1, 20)

    invalid_param!(:limit)
  end

  private

  def limit
    context.params[:limit]
  end
end
