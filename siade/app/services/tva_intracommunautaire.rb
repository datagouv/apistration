class TVAIntracommunautaire
  attr_reader :siren

  def initialize(siren)
    @siren = siren
  end

  def perform
    "FR#{cle}#{siren}"
  end

  def cle
    cle = ((((siren.to_i % 97) * 3) + 12) % 97).to_s
    cle.rjust(2, '0')
  end
end
