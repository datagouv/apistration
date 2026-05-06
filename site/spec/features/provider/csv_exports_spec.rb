RSpec.describe 'Provider: CSV exports', app: :api_entreprise do
  let(:user) { create(:user, provider_uids: %w[insee]) }

  before { login_as(user) }

  describe 'consumers.csv' do
    it 'returns CSV with BOM, semicolon separator and translated headers' do
      page.driver.get provider_consumers_csv_path(provider_uid: 'insee')

      expect(page.response_headers['Content-Type']).to include('text/csv')
      expect(page.response_headers['Content-Disposition']).to include('provider-consumers_csv-')
      expect(page.body).to start_with('﻿')
      expect(page.body).to include('DataPass ID;Intitulé;Email demandeur;SIRET;Raison sociale;Total;Unique')
    end

    it 'redirects when accessing a foreign provider' do
      page.driver.get provider_consumers_csv_path(provider_uid: 'inpi')

      expect(page.driver.response.status).to eq(302)
      expect(page.driver.response.location).to end_with(root_path)
    end
  end

  describe 'habilitations.csv' do
    it 'returns CSV with translated headers' do
      page.driver.get provider_habilitations_csv_path(provider_uid: 'insee')

      expect(page.response_headers['Content-Type']).to include('text/csv')
      expect(page.body).to include('DataPass ID;Intitulé;SIRET;Raison sociale;Email demandeur;Statut;Scopes')
    end
  end
end
