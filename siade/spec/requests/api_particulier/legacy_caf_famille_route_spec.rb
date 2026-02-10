require 'rails_helper'

RSpec.describe 'API Particulier legacy /api/caf/famille' do
  it 'returns 410 Gone instead of raising MissingController (non-regression test)' do
    host!('particulier.api.gouv.fr')

    get('/api/caf/famille')

    expect(response).to have_http_status(:gone)
    expect(response.body).to include("n'est plus disponible")
  end
end
