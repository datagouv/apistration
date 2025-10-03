class DGFIP::AbstractDGFIPTool < ApplicationTool
  def self.format_params(params)
    params[:request_id] = params[:context].delete(:request_id)
    params[:user_id] = params[:context].delete(:user_id)
    params
  end
end
