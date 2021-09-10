class SIADE::V2::Adapters::LiassesFiscalesDGFIP
  extend ActiveSupport::Concern

  attr_reader :user_id, :siren, :annee

  def initialize(user_id, siren, annee)
    @user_id = user_id
    @siren = siren
    @annee = annee
  end

  def to_query
    hash_cleaned = to_hash.delete_if { |_k, v| v.blank? }
    hash_cleaned.collect do |k, v|
      "#{k}=#{v}"
    end.sort * '&'
  end

  def to_hash
    retour = {
      userId: user_id,
      annee: annee
    }

    retour = retour.merge(siren: siren) unless siren.empty?

    retour
  end
end
