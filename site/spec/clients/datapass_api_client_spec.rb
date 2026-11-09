RSpec.describe DatapassAPIClient do
  subject(:client) { described_class.new }

  let(:url) { 'https://datapass.example.test/api/v1' }
  let(:access_token) { 'datapass_access_token' }
  let(:demande) { JSON.parse(Rails.root.join('spec/fixtures/datapass_api/demande.json').read) }
  let(:json_headers) { { 'Content-Type' => 'application/json' } }

  before do
    stub_credential(:datapass_api, url:, client_id: 'datapass_client_id', client_secret: 'datapass_client_secret')
    stub_token_endpoint
  end

  def stub_token_endpoint
    stub_request(:post, "#{url}/oauth/token")
      .to_return(status: 200, headers: json_headers, body: { access_token:, token_type: 'Bearer', expires_in: 7200 }.to_json)
  end

  def stub_datapass(method, path, status: 200, body: demande)
    stub_request(method, "#{url}/#{path}")
      .with(headers: { 'Authorization' => "Bearer #{access_token}" })
      .to_return(status:, headers: json_headers, body: body.to_json)
  end

  def validation_errors
    {
      'errors' => [
        {
          'status' => '422',
          'source' => { 'pointer' => '/data/attributes/nom' },
          'title' => 'Validation Error',
          'detail' => 'Le nom ne peut pas être vide.'
        }
      ]
    }
  end

  describe '#get_demande' do
    subject(:get_demande) { client.get_demande(123) }

    context 'when the demande exists' do
      before { stub_datapass(:get, 'demandes/123') }

      it 'returns the demande' do
        expect(get_demande).to eq(demande)
      end
    end

    context 'when the demande does not exist' do
      before { stub_datapass(:get, 'demandes/123', status: 404, body: { errors: [{ status: '404', title: 'Not Found', detail: 'Not Found' }] }) }

      it 'raises a not found error' do
        expect { get_demande }.to raise_error(described_class::NotFound) do |error|
          expect(error.status).to eq(404)
        end
      end
    end

    context 'when the token is rejected' do
      before { stub_datapass(:get, 'demandes/123', status: 401, body: { errors: [] }) }

      it 'raises an unauthorized error and asks for a new token on the next call' do
        2.times { expect { client.get_demande(123) }.to raise_error(described_class::Unauthorized) }

        expect(a_request(:post, "#{url}/oauth/token")).to have_been_made.twice
      end
    end

    context 'when the API right is missing' do
      let(:missing_right) { { 'errors' => [{ 'status' => '403', 'title' => 'Droit API manquant', 'detail' => 'Droit de soumission absent.' }] } }

      before { stub_datapass(:get, 'demandes/123', status: 403, body: missing_right) }

      it 'raises a forbidden error exposing the reason' do
        expect { get_demande }.to raise_error(described_class::Forbidden) do |error|
          expect(error.status).to eq(403)
          expect(error.errors).to eq(missing_right['errors'])
        end
      end
    end

    context 'when DataPass fails' do
      before { stub_request(:get, "#{url}/demandes/123").to_return(status: 500, body: 'Internal Server Error') }

      it 'raises a generic error' do
        expect { get_demande }.to raise_error(described_class::Error) do |error|
          expect(error.status).to eq(500)
        end
      end
    end

    context 'when DataPass times out' do
      before { stub_request(:get, "#{url}/demandes/123").to_timeout }

      it 'raises a generic error without status' do
        expect { get_demande }.to raise_error(described_class::Error) do |error|
          expect(error.status).to be_nil
        end
      end
    end
  end

  describe '#list_demandes' do
    before do
      stub_request(:get, "#{url}/demandes")
        .with(query: expected_query, headers: { 'Authorization' => "Bearer #{access_token}" })
        .to_return(status: 200, headers: json_headers, body: [demande].to_json)
    end

    context 'without filters' do
      subject(:list_demandes) { client.list_demandes }

      let(:expected_query) { {} }

      it 'returns the demandes' do
        expect(list_demandes).to eq([demande])
      end
    end

    context 'with filters and pagination' do
      subject(:list_demandes) { client.list_demandes(siret: '13002526500013', state: %w[draft submitted], limit: 100, offset: 200) }

      let(:expected_query) { { siret: '13002526500013', state: %w[draft submitted], limit: 100, offset: 200 } }

      it 'returns the matching demandes' do
        expect(list_demandes).to eq([demande])
      end
    end
  end

  describe '#create_demande' do
    subject(:create_demande) { client.create_demande(attributes) }

    let(:attributes) do
      {
        form_uid: 'api-entreprise-marches-publics',
        applicant: { email: 'demandeur@example.com', given_name: 'Jean', family_name: 'Dupont' },
        organization: { siret: '13002526500013' },
        data: { intitule: 'Marchés publics' },
        metadata: { campagne: 'migration-editeur-x', lot: 3, prioritaire: true }
      }
    end

    context 'when DataPass accepts the demande' do
      let!(:create_request) do
        stub_datapass(:post, 'demandes', status: 201)
          .with(body: { demande: attributes }.to_json, headers: json_headers.merge('Authorization' => "Bearer #{access_token}"))
      end

      it 'returns the created demande' do
        expect(create_demande).to eq(demande)
        expect(create_request).to have_been_requested
      end
    end

    context 'when DataPass rejects the demande' do
      before { stub_datapass(:post, 'demandes', status: 422, body: validation_errors) }

      it 'raises an unprocessable entity error exposing the validation errors' do
        expect { create_demande }.to raise_error(described_class::UnprocessableEntity) do |error|
          expect(error.errors).to eq(validation_errors['errors'])
        end
      end
    end
  end

  describe '#update_demande' do
    subject(:update_demande) { client.update_demande(123, attributes) }

    let(:attributes) { { data: { intitule: 'Nouvel intitulé' } } }

    context 'when DataPass accepts the update' do
      let!(:update_request) do
        stub_datapass(:patch, 'demandes/123')
          .with(body: { demande: attributes }.to_json)
      end

      it 'returns the updated demande and leaves absent metadata untouched' do
        expect(update_demande).to eq(demande)
        expect(update_request).to have_been_requested
      end

      context 'with metadata replacing the existing ones' do
        let(:attributes) { { data: { intitule: 'Nouvel intitulé' }, metadata: { campagne: 'relance' } } }

        it 'sends them' do
          update_demande

          expect(update_request).to have_been_requested
        end
      end

      context 'with null metadata to erase the existing ones' do
        let(:attributes) { { metadata: nil } }

        it 'sends an explicit null' do
          update_demande

          expect(a_request(:patch, "#{url}/demandes/123").with(body: '{"demande":{"metadata":null}}')).to have_been_made
        end
      end
    end

    context 'when DataPass rejects the update' do
      before { stub_datapass(:patch, 'demandes/123', status: 422, body: validation_errors) }

      it 'raises an unprocessable entity error' do
        expect { update_demande }.to raise_error(described_class::UnprocessableEntity)
      end
    end
  end

  describe '#list_formulaires' do
    subject(:list_formulaires) { client.list_formulaires('api_entreprise') }

    let(:formulaires) { JSON.parse(Rails.root.join('spec/fixtures/datapass_api/formulaires.json').read) }

    context 'when the definition is accessible' do
      before { stub_datapass(:get, 'definitions/api_entreprise/formulaires', body: formulaires) }

      it 'returns the formulaires of the definition' do
        expect(list_formulaires).to eq(formulaires)
      end
    end

    context 'when the definition is not accessible' do
      before { stub_datapass(:get, 'definitions/api_entreprise/formulaires', status: 404, body: { error: 'Not Found' }) }

      it 'raises a not found error' do
        expect { list_formulaires }.to raise_error(described_class::NotFound)
      end
    end
  end

  describe '#submit_demande' do
    subject(:submit_demande) { client.submit_demande(123, consentement:) }

    let(:consentement) { { terms_of_service_accepted: true, cgu_alternative_franceconnect: false } }
    let(:submitted_demande) { demande.merge('state' => 'submitted') }

    context 'when the demande is complete' do
      let!(:submit_request) do
        stub_datapass(:post, 'demandes/123/soumettre', body: submitted_demande)
          .with(body: { consentement: }.to_json)
      end

      it 'returns the submitted demande, sending only the consents' do
        expect(submit_demande).to eq(submitted_demande)
        expect(submit_request).to have_been_requested
      end
    end

    context 'when the caller declares verified emails and disables mandatory notifications' do
      subject(:submit_demande) { client.submit_demande(123, consentement:, verified_email: true, notifications: false) }

      let(:warning) { { 'title' => 'Notifications obligatoires', 'detail' => 'Le paramètre `notifications` a été ignoré.' } }

      before do
        stub_datapass(:post, 'demandes/123/soumettre', body: submitted_demande.merge('meta' => { 'warnings' => [warning] }))
          .with(body: { consentement:, verified_email: true, notifications: false }.to_json)
      end

      it 'sends both flags and exposes the warning' do
        expect(submit_demande.dig('meta', 'warnings')).to eq([warning])
      end
    end

    context 'when the demande is incomplete' do
      let(:missing_field) do
        {
          'errors' => [
            {
              'status' => '422',
              'title' => 'Demande invalide',
              'detail' => 'Nom de famille du délégué à la protection des données doit être rempli(e)',
              'source' => { 'pointer' => '/data/delegue_protection_donnees_family_name' }
            }
          ]
        }
      end

      before { stub_datapass(:post, 'demandes/123/soumettre', status: 422, body: missing_field) }

      it 'raises an unprocessable entity error exposing title and pointer' do
        expect { submit_demande }.to raise_error(described_class::UnprocessableEntity) do |error|
          expect(error.errors).to eq(missing_field['errors'])
        end
      end
    end

    context 'when the demande was not created through the API' do
      let(:not_created_by_api) { { 'errors' => [{ 'status' => '403', 'title' => 'Demande non créée par API', 'detail' => 'Demande réservée à son demandeur.' }] } }

      before { stub_datapass(:post, 'demandes/123/soumettre', status: 403, body: not_created_by_api) }

      it 'raises a forbidden error exposing the reason' do
        expect { submit_demande }.to raise_error(described_class::Forbidden) do |error|
          expect(error.errors).to eq(not_created_by_api['errors'])
        end
      end
    end
  end

  describe '#validate_demande' do
    subject(:validate_demande) { client.validate_demande(123, instructeur_email: 'instructeur@example.com') }

    let(:validated_demande) { demande.merge('state' => 'validated') }

    context 'when the demande can be validated' do
      let!(:validate_request) do
        stub_datapass(:post, 'demandes/123/valider', body: validated_demande)
          .with(body: { instructeur: { email: 'instructeur@example.com' } }.to_json)
      end

      it 'returns the validated demande, sending only the instructeur' do
        expect(validate_demande).to eq(validated_demande)
        expect(validate_request).to have_been_requested
      end
    end

    context 'with a message and notifications disabled' do
      subject(:validate_demande) { client.validate_demande(123, instructeur_email: 'instructeur@example.com', message: 'Migration Omnikles', notifications: false) }

      let!(:validate_request) do
        stub_datapass(:post, 'demandes/123/valider', body: validated_demande)
          .with(body: { instructeur: { email: 'instructeur@example.com' }, message: 'Migration Omnikles', notifications: false }.to_json)
      end

      it 'sends them' do
        validate_demande

        expect(validate_request).to have_been_requested
      end
    end

    context 'when the demande state does not allow validation' do
      let(:wrong_state) { { 'errors' => [{ 'status' => '422', 'title' => 'État non modifiable', 'detail' => "La demande ne peut pas être modifiée dans l'état actuel." }] } }

      before { stub_datapass(:post, 'demandes/123/valider', status: 422, body: wrong_state) }

      it 'raises an unprocessable entity error' do
        expect { validate_demande }.to raise_error(described_class::UnprocessableEntity) do |error|
          expect(error.errors).to eq(wrong_state['errors'])
        end
      end
    end
  end
end
