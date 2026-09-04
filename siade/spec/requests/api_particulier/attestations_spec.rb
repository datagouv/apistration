RSpec.describe 'API Particulier: téléchargement d\'attestation PDF', api: :particulier do
  subject(:download) { get "/api/attestations/#{token}.pdf" }

  before { Rack::Attack.reset! }
  after { Rack::Attack.reset! }

  let(:data) do
    {
      'allocataires' => [
        { 'nom_naissance' => 'DUPOND', 'prenoms' => 'JEAN-MICHEL', 'date_naissance' => '1981-06-30', 'sexe' => 'M' }
      ],
      'enfants' => [
        { 'nom_naissance' => 'DUPOND', 'prenoms' => 'MARIE', 'date_naissance' => '2020-03-15', 'sexe' => 'F' }
      ],
      'parametres_calcul_participation_familiale' => {
        'nombre_enfants_a_charge' => 1,
        'base_ressources_annuelles' => { 'valeur' => 40_923, 'annee_calcul' => 2023 }
      }
    }
  end

  let(:proof) do
    CNAV::ParticipationFamilialeEAJE::BuildAttestationProof.call(
      generate_proof_mode: 'pdf',
      scopes: %w[
        cnav_participation_familiale_eaje_allocataires
        cnav_participation_familiale_eaje_enfants
        cnav_participation_familiale_eaje_parametres_calcul
      ],
      recipient: '13002526500013',
      habilitation: 'a11b0000-0000-0000-0000-000000000042',
      bundled_data: BundledData.new(data: Resource.new(data))
    )
  end

  let(:verification_token) { proof.verification_token }
  let(:token) { proof.pdf_token }

  context 'with a fresh link and no authentication' do
    it 'serves the full attestation PDF with its verification footer' do
      download

      expect(response).to have_http_status(:ok)
      expect(response.headers['Content-Type']).to eq('application/pdf')

      text = PDF::Reader.new(StringIO.new(response.body)).pages.map(&:text).join(' ').squish

      expect(text).to include('ALLOCATAIRES')
      expect(text).to include('Nom de naissance DUPOND')
      expect(text).to include('13002526500013')
      expect(text).to include('a11b0000-0000-0000-0000-000000000042')
      expect(text).to include("Code de vérification : #{AttestationToken.visual_code(verification_token)}")
      expect(text).not_to include('DONNÉES DE TEST')
    end

    it 'anchors the QR target on the configured base, never on the request host' do
      download

      doc = HexaPDF::Document.new(io: StringIO.new(response.body))
      links = doc.pages.first[:Annots].to_a.select { |annotation| annotation[:Subtype] == :Link }

      expect(links).not_to be_empty
      expect(links.map { |annotation| annotation[:A][:URI] })
        .to all(start_with("#{AttestationToken.base_url}/attestations/verification/"))
    end

    it 'is downloadable multiple times' do
      2.times do
        get "/api/attestations/#{token}.pdf"

        expect(response).to have_http_status(:ok)
      end
    end

    it 'forbids caching' do
      download

      expect(response.headers['Cache-Control']).to include('no-store')
    end
  end

  context 'with a stale link' do
    it 'returns 410 Gone without any data' do
      stale = token

      Timecop.travel(6.minutes.from_now) do
        get "/api/attestations/#{stale}.pdf"
      end

      expect(response).to have_http_status(:gone)
      expect(response.body).not_to include('DUPOND')
    end
  end

  context 'with a tampered token' do
    let(:token) { proof.verification_token }

    it 'returns a plain 404' do
      download

      expect(response).to have_http_status(:not_found)
      expect(response.body).not_to include('DUPOND')
    end
  end

  context 'with garbage in place of a token' do
    let(:token) { 'garbage' }

    it 'returns a plain 404' do
      download

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when called repeatedly from the same IP' do
    it 'throttles beyond 60 requests per minute — the link is consumed by software, batch-wise' do
      Timecop.freeze do
        60.times do
          get '/api/attestations/garbage.pdf', env: { 'REMOTE_ADDR' => '203.0.113.7' }
          expect(response).to have_http_status(:not_found)
        end

        get "/api/attestations/#{token}.pdf", env: { 'REMOTE_ADDR' => '203.0.113.7' }

        expect(response).to have_http_status(:too_many_requests)
      end
    end
  end
end
