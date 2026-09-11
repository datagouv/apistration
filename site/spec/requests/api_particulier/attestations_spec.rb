require 'rails_helper'

RSpec.describe 'Attestation verification page' do
  subject(:verification) { get "/attestations/verification/#{token}" }

  before do
    host! 'particulier.api.localtest.me'
    Rails.cache.clear
  end

  let(:key) do
    ActiveSupport::KeyGenerator.new('attestation_encryptor_password').generate_key('attestation_encryptor_salt', 32)
  end
  let(:encryptor) do
    ActiveSupport::MessageEncryptor.new(key, url_safe: true, serializer: ActiveSupport::MessageEncryptor::NullSerializer)
  end

  let(:payload) do
    {
      'siret' => '13002526500013',
      'emise_le' => '2026-07-29',
      'valable_jusqu_au' => '2031-07-29',
      'sections' => [
        { 'titre' => 'Allocataires',
          'entrees' => [[['Nom de naissance', 'DUP•••'], ['Date de naissance', '06/1981']]] },
        { 'titre' => 'Enfants',
          'entrees' => [[["Nombre d'enfants", '2']]] },
        { 'titre' => 'Paramètres de calcul de la participation familiale',
          'entrees' => [[["Nombre d'enfants à charge", '2'],
                         ['Base de ressources annuelles', { 'highlight' => '40 923' }],
                         ['Année de calcul', '2023']]] }
      ]
    }
  end

  let(:token) do
    encryptor.encrypt_and_sign(Zlib::Deflate.deflate(payload.to_json), purpose: :attestation_verification, expires_in: 5.years)
  end

  context 'with a valid token and no authentication' do
    it 'serves the DSFR verification page with truncated data' do
      verification

      expect(response).to have_http_status(:ok)
      expect(response.headers['Content-Type']).to include('text/html')

      expect(response.body).to include("Contrôle de l'attestation")
      expect(response.body).to include('fr-alert--success')
      expect(response.body).to include('authentique et valide')
      expect(response.body).to include('DUP•••')
      expect(response.body).to include('06/1981')
      expect(response.body).to include('13002526500013')
      expect(response.body).to include('Nombre d&#39;enfants')
      expect(response.body).to include('40 923')
      expect(response.body).to include('Émise le')
      expect(response.body).to include('29/07/2026')
      expect(response.body).to include('Valable jusqu&#39;au')
      expect(response.body).to include('29/07/2031')
      expect(response.body).to include('particulier.api.gouv.fr')
      expect(response.body).not_to include('DUPOND')
    end

    it 'shows the visual code derived from the token' do
      verification

      expect(response.body).to match(/[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{2}/)
    end

    it 'loads no external resource and runs no script' do
      verification

      expect(response.body).not_to include('https://')
      expect(response.body).not_to include('<script')
    end

    it 'warns that the document is test data outside production' do
      verification

      expect(response.body).to include('Données de test')
    end

    it 'omits the test banner in production' do
      allow(Rails.env).to receive(:production?).and_return(true)

      verification

      expect(response.body).not_to include('Données de test')
    end
  end

  RSpec.shared_examples 'forbids caching and indexing' do
    it 'forbids caching and indexing' do
      verification

      expect(response.headers['Cache-Control']).to include('no-store')
      expect(response.headers['X-Robots-Tag']).to eq('noindex')
    end
  end

  it_behaves_like 'forbids caching and indexing'

  context 'with a tampered token' do
    let(:token) do
      encryptor.encrypt_and_sign(Zlib::Deflate.deflate(payload.to_json), purpose: :attestation_eaje_verification_v1).tr('AB', 'BA')
    end

    it 'returns a 404 page without any data' do
      verification

      expect(response).to have_http_status(:not_found)
      expect(response.body).not_to include('DUP')
      expect(response.body).to include('fr-alert--error')
      expect(response.body).to include('invalide ou expiré')
    end

    it_behaves_like 'forbids caching and indexing'
  end

  context 'with an expired token' do
    it 'returns the same 404 page' do
      expired = token

      Timecop.travel(5.years.from_now + 1.day) do
        get "/attestations/verification/#{expired}"
      end

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with garbage in place of a token' do
    let(:token) { 'garbage' }

    it 'returns a plain 404' do
      verification

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when called repeatedly from the same IP' do
    it 'throttles beyond 5 requests per minute' do
      5.times do
        get "/attestations/verification/#{token}"
        expect(response).not_to have_http_status(:too_many_requests)
      end

      get "/attestations/verification/#{token}"

      expect(response).to have_http_status(:too_many_requests)
    end
  end
end
