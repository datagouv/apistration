class ErrorsController < ActionController::API
  def not_found
    render plain: 'Not found',
      status: :not_found
  end
end
