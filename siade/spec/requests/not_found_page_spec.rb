require 'rails_helper'

RSpec.describe 'Not found page' do
  describe 'global not found' do
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

  describe 'gone response for API Entreprise' do
    subject(:call) do
      get '/v2/entreprises/123456789'

      response
    end

    context 'when it is on API Entreprise', api: :entreprise do
      it 'renders gone text' do
        expect(call.body).to include('Cette URL n\'existe plus')
      end

      it 'renders 410 status' do
        expect(call.status).to eq(410)
      end
    end

    context 'when it is not on API Entreprise', api: :particulier do
      it 'renders not found text' do
        expect(call.body).to include('Cette URL n\'existe pas')
      end

      it 'renders 404 status' do
        expect(call.status).to eq(404)
      end
    end
  end

  describe 'deprecated Actes endpoint', api: :entreprise do
    subject(:call) do
      get "/v3/inpi/unites_legales/#{valid_siren(:inpi)}/actes"

      response
    end

    it 'renders error text' do
      expect(call.body).to include('Cette route a été déplacée. Merci de mettre à jour votre application vers la nouvelle route. Vous pouvez consulter la documentation à l\'adresse suivante: https://entreprise.api.gouv.fr/catalogue/inpi/rne/actes_bilans')
    end

    it 'renders 410 status' do
      expect(call.status).to eq(410)
    end
  end
end
