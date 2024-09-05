# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API Particulier: tracking encrypted params' do
  subject(:make_request) do
    get '/api/v2/situations-pole-emploi', params:, headers: { 'X-Api-Key' => TokenFactory.new(scopes).valid }
  end

  let(:scopes) { %w[pole_emploi_identite pole_emploi_adresse pole_emploi_contact pole_emploi_inscription] }
  let(:params) do
    {
      identifiant: 'identifiant'
    }
  end

  before do
    host! 'particulier.api.localtest.me'

    stub_request(:post, Siade.credentials[:pole_emploi_status_url]).to_return(
      status: 200,
      body: 'invalid'
    )
  end

  it 'calls encrypt data service', vcr: { cassette_name: 'pole_emploi/oauth2' } do
    expect(EncryptData).to receive(:new).and_call_original

    subject
  end
end
