class RNAId
  attr_accessor :rna_id

  include ActiveModel::Validations

  validates :rna_id, rna_id_format: true

  def initialize(rna_id = nil)
    @rna_id = rna_id
  end

  def to_s
    @rna_id
  end
end
