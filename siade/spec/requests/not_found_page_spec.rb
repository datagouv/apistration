require 'rails_helper'

RSpec.describe 'Not found page', type: :request do
  subject(:call) do
    get '/whatever'

    response
  end

  it 'renders not found text' do
    expect(call.body).to eq('Not found')
  end

  it 'renders 404 status' do
    expect(call.status).to eq(404)
  end
end
