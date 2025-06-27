# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIEntreprise::INPI::RNE::ExtraitDownloadSerializer::V3, type: :serializer do
  subject { serializer.new(dummy_object, current_user).serializable_hash }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes: [], jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }
  let(:serializer) { described_class }

  let(:dummy_object) do
    data = Resource.new({
      document_url: 'https://example.com/document.pdf',
      expires_in: 3600
    })

    BundledData.new(data:)
  end

  before do
    allow(ProxiedFileService).to receive(:set).and_return('uuid')
  end

  it 'serializes the document with proxied URL' do
    expect(subject).to eq({
      data: {
        document_url: 'http://test.entreprise.api.gouv.fr/proxy/files/uuid',
        expires_in: 3600
      },
      links: {},
      meta: {}
    })
  end

  context 'when ProxiedFileService raises a connection error' do
    before do
      allow(ProxiedFileService).to receive(:set).and_raise(ProxiedFileService::ConnectionError)
    end

    it 'fallbacks to original url' do
      expect(subject[:data][:document_url]).to eq('https://example.com/document.pdf')
    end
  end
end
