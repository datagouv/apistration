
class ValidateSiret < ApplicationInteractor
  before do
    context.errors ||= []
  end

  def call
    return if siret.valid?

    context.errors << UnprocessableEntityError.new(:siret)
    context.fail!
  end

  private

  def siret
    @siret ||= Siret.new(params[:siret])
  end

  def params
    context.params
  end
end
