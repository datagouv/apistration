class DGFIPPotentialNotFoundError < ApplicationError
  def code
    '03501'
  end

  def meta
    {
      provider: 'DGFIP'
    }
  end

  def kind
    :provider_error
  end
end
