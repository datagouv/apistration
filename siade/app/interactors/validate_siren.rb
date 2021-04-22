class ValidateSiren < ApplicationInteractor
  before do
    context.errors ||= []
  end

  def call
    return if siren.valid?

    context.errors << UnprocessableEntityError.new(:siren)
    context.status = 422
    context.fail!
  end

  private

  def siren
    @siren ||= Siren.new(params[:siren])
  end

  def params
    context.params
  end
end
