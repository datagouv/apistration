class RNFId
  attr_accessor :rnf_id

  include ActiveModel::Validations

  validates :rnf_id, rnf_id_format: true

  def initialize(rnf_id = nil)
    @rnf_id = rnf_id
  end

  def to_s
    @rnf_id
  end
end
