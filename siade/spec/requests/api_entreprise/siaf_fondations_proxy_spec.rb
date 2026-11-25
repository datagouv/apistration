require 'rails_helper'

RSpec.describe 'MI - SIAF : Fondations, download of an attachment', api: :entreprise do
  subject(:download) { get URI(link).path }

  let(:authorization_request) { AuthorizationRequest.create!(scopes:) }
  let(:token) { Token.create!(authorization_request:, iat: 1.day.ago.to_i, exp: 1.day.from_now.to_i) }
  let(:scopes) { %w[fondations_mi_siaf fondations_mi_siaf_comptes] }
  let(:bearer) { TokenFactory.new(scopes).valid(uid: token.id) }
  let(:attachment_content) { "%PDF-1.4\n1 0 obj<<>>endobj\ntrailer<<>>\n%%EOF" }

  let(:link) do
    get "/v3/ministere_interieur/siaf/fondations/#{valid_rnf_id}",
      params: { recipient: valid_siret, context: 'test', object: 'test' },
      headers: { 'Authorization' => "Bearer #{bearer}" }

    response_json[:data][:documents].find { |document| document[:type] == 'Comptes' }[:url]
  end

  let!(:siaf_attachment) do
    stub_request(:get, "#{Siade.credentials[:siaf_url]}/api/v1/fondations/#{valid_rnf_id}/attachment/accounts-file")
      .with(headers: { 'Token' => Siade.credentials[:siaf_token] })
      .to_return(status: 200, body: attachment_content)
  end

  before do
    payload = JSON.parse(read_payload_file('mi/siaf/fondations/valid.json'))
    payload['files'] = [payload['files'].first.merge('id' => 'accounts-file', 'typeFile' => 'Comptes')]

    stub_siaf_fondation(body: payload.to_json)
  end

  it 'serves a download url of the file fetched from the SIAF' do
    download

    expect(response).to have_http_status(:ok)
    expect(response_json[:data][:document_url]).to match(%r{\Ahttp://test\.entreprise\.api\.gouv\.fr/proxy/files/[a-f0-9-]{36}\z})
    expect(siaf_attachment).to have_been_requested
  end

  context 'when the token lost the scope of the attachment after getting the link' do
    it 'refuses the download without calling the SIAF' do
      link
      authorization_request.update!(scopes: %w[fondations_mi_siaf])

      download

      expect(response).to have_http_status(:forbidden)
      expect(siaf_attachment).not_to have_been_requested
    end
  end

  context 'when the token was blacklisted after getting the link' do
    it 'refuses the download without calling the SIAF' do
      link
      token.update!(blacklisted_at: 1.minute.ago)

      download

      expect(response).to have_http_status(:unauthorized)
      expect(siaf_attachment).not_to have_been_requested
    end
  end

  context 'when DataPass archived the authorization request after a new version, the token staying valid' do
    it 'still downloads, as the main call still serves the link' do
      link
      authorization_request.update!(status: 'archived')

      download

      expect(response).to have_http_status(:ok)
    end
  end

  context 'when the token expired after getting the link' do
    it 'refuses the download without calling the SIAF' do
      link
      token.update!(exp: 1.minute.ago.to_i)

      download

      expect(response).to have_http_status(:unauthorized)
      expect(siaf_attachment).not_to have_been_requested
    end
  end

  context 'with an editor token acting for a delegating organisation' do
    let(:authorization_request) { AuthorizationRequest.create!(scopes:, siret: valid_siret) }
    let(:editor) { Editor.create!(name: 'Éditeur') }
    let(:editor_token) { EditorToken.create!(editor:, iat: 1.day.ago.to_i, exp: 1.day.from_now.to_i) }
    let(:bearer) { TokenFactory.new([]).editor_valid(uid: editor_token.id) }
    let!(:delegation) { EditorDelegation.create!(editor:, authorization_request:) }

    it 'downloads with the scopes of the delegation' do
      download

      expect(response).to have_http_status(:ok)
    end

    it 'refuses the download once the delegation is revoked, without calling the SIAF' do
      link
      delegation.update!(revoked_at: 1.minute.ago)

      download

      expect(response).to have_http_status(:unauthorized)
      expect(siaf_attachment).not_to have_been_requested
    end
  end

  context 'when the link is more than an hour old' do
    it 'refuses the download' do
      link

      Timecop.travel(61.minutes.from_now) { download }

      expect(response).to have_http_status(:gone)
    end
  end

  {
    'an HTML error page' => '<!DOCTYPE html><html><body>Une erreur est survenue</body></html>',
    'a JSON error' => '{"error":"attachment unavailable"}'
  }.each do |answer, error_body|
    context "when the SIAF answers #{answer} with a 200" do
      let(:attachment_content) { error_body }

      it 'reports an unknown SIAF answer instead of storing it as the attachment' do
        download

        expect(response).to have_http_status(:bad_gateway)
        expect(response_json[:errors].first[:code]).to eq('44999')
      end
    end
  end
end
