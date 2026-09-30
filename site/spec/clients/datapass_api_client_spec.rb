RSpec.describe DatapassAPIClient do
  subject(:client) { described_class.new }

  let(:url) { 'https://datapass.example.test/api/v1' }
  let(:access_token) { 'datapass_access_token' }
  let(:demande) { JSON.parse(Rails.root.join('spec/fixtures/datapass_api/demande.json').read) }
  let(:json_headers) { { 'Content-Type' => 'application/json' } }

  before do
    stub_credential(:datapass_api, url:, client_id: 'datapass_client_id', client_secret: 'datapass_client_secret')
    allow(DatapassAPIAuthentication).to receive(:new).and_return(instance_double(DatapassAPIAuthentication, access_token:))
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
      before do
        allow(DatapassAPIAuthentication).to receive(:invalidate_token_cache!)
        stub_datapass(:get, 'demandes/123', status: 401, body: { errors: [] })
      end

      it 'raises an unauthorized error and forgets the cached token' do
        expect { get_demande }.to raise_error(described_class::Unauthorized)
        expect(DatapassAPIAuthentication).to have_received(:invalidate_token_cache!)
      end
    end

    context 'when the token lacks the required scope' do
      before { stub_datapass(:get, 'demandes/123', status: 403, body: { errors: [] }) }

      it 'raises an unauthorized error' do
        expect { get_demande }.to raise_error(described_class::Unauthorized) do |error|
          expect(error.status).to eq(403)
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
        data: { intitule: 'Marchés publics' }
      }
    end

    context 'when DataPass accepts the demande' do
      let!(:create_request) do
        stub_datapass(:post, 'demandes', status: 201)
          .with(body: { demande: attributes }.to_json, headers: json_headers)
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
    subject(:update_demande) { client.update_demande(123, data) }

    let(:data) { { intitule: 'Nouvel intitulé' } }

    context 'when DataPass accepts the update' do
      let!(:update_request) do
        stub_datapass(:patch, 'demandes/123')
          .with(body: { demande: { data: } }.to_json)
      end

      it 'returns the updated demande' do
        expect(update_demande).to eq(demande)
        expect(update_request).to have_been_requested
      end
    end

    context 'when DataPass rejects the update' do
      before { stub_datapass(:patch, 'demandes/123', status: 422, body: validation_errors) }

      it 'raises an unprocessable entity error' do
        expect { update_demande }.to raise_error(described_class::UnprocessableEntity)
      end
    end
  end
end
