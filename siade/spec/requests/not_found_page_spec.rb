require 'rails_helper'

RSpec.describe 'Not found page' do
  subject(:call) do
    get '/whatever'

    response
  end

  it 'renders not found text' do
    expect(call.body).to include('Cette URL n\'existe pas')
  end

  it 'renders 404 status' do
    expect(call.status).to eq(404)
  end
end
