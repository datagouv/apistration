class APIEntreprise::V2::LiassesFiscalesDGFIPController < APIEntreprise::V2::AbstractLiassesFiscalesDGFIPController
  def show
    dgfip_action(request_type: :declaration)
  end
end
