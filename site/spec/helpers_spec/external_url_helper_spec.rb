require 'rails_helper'

RSpec.describe ExternalUrlHelper, type: :helper do
  describe 'external URLs to DataPass' do
    let(:token) { create(:token, authorization_request:) }
    let(:authorization_request) { create(:authorization_request) }
    let(:external_id) { authorization_request.external_id }

    describe '#datapass_authorization_request_url' do
      it 'returns the DataPass\' authorization request URL' do
        expect(datapass_authorization_request_url(authorization_request)).to include("datapass.api.gouv.fr/api-#{authorization_request.api}/#{external_id}")
      end
    end
  end
end
