class DGFIPPotentialNotFoundError < ApplicationError
  def code
    '03501'
  end

  def meta
    {
      provider: 'DGFIP',
    }
  end
end
