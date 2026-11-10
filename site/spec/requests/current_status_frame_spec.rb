require 'rails_helper'

RSpec.describe 'Current status frame' do
  before do
    allow_any_instance_of(StatusPage).to receive(:current_status).and_return(:up) # rubocop:todo RSpec/AnyInstance
  end

  {
    'API Entreprise' => ['entreprise.api.localtest.me', '/apis/status'],
    'API Particulier' => ['particulier.api.localtest.me', '/status/apis']
  }.each do |site, (host, path)|
    context "with #{site}" do
      before { host! host }

      it 'answers the header frame with its own id' do
        get path, headers: { 'Turbo-Frame' => 'current_status' }

        expect(response.body).to include('<turbo-frame id="current_status">')
      end

      it 'answers the copy of the header frame DSFR puts in the mobile menu with the id of this copy' do
        get path, headers: { 'Turbo-Frame' => 'current_status-mobile' }

        expect(response.body).to include('<turbo-frame id="current_status-mobile">')
      end

      it 'keeps the default frame id when the page is opened directly' do
        get path

        expect(response.body).to include('<turbo-frame id="current_status">')
      end
    end
  end
end
