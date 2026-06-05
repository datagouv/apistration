class Admin::AdminActivitiesController < AdminController
  def index
    @q = AdminActivity.where(namespace:).includes(:admin).ransack(params[:q])
    @activities = @q.result.recent.page(params[:page])
  end
end
