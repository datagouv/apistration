class Siret
  include ActiveModel::Validations

  attr_reader :siret

  validates :siret, siret_format: true

  def initialize(siret = nil)
    @siret = siret
  end

  def to_s
    @siret
  end
end
