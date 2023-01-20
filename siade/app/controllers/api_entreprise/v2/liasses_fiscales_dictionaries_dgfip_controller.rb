class APIEntreprise::V2::LiassesFiscalesDictionariesDGFIPController < APIEntreprise::V2::AbstractLiassesFiscalesDGFIPController
  def show
    dgfip_action(request_type: :dictionary)
  end
end
