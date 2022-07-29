class APIParticulier::V2::DummyController < APIParticulierController
  def show
    render json: {
      hello: 'world'
    }, status: :ok
  end
end
