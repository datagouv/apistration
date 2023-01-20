class APIEntreprise::V2::LiassesFiscalesCompleteDGFIPController < APIEntreprise::V2::AbstractLiassesFiscalesDGFIPController
  def show
    dgfip_action(request_type: :both)
  end
end
