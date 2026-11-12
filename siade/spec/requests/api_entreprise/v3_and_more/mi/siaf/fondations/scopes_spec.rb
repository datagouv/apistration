require 'rails_helper'

RSpec.describe 'MI - SIAF : Fondations, data served per scope', api: :entreprise do
  subject(:call_endpoint) do
    get "/v3/ministere_interieur/siaf/fondations/#{valid_rnf_id}",
      params: { recipient: valid_siret, context: 'test', object: 'test' },
      headers: { 'Authorization' => "Bearer #{TokenFactory.new(scopes).valid}" }
  end

  let(:fondation) { response_json[:data] }

  before { stub_siaf_fondation }

  context 'with the socle scope only, granted to every protected use case' do
    let(:scopes) { %w[fondations_mi_siaf] }

    it 'serves the directors in office but neither the beneficial owners nor the control data' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(fondation[:dirigeants].pluck(:nom)).to eq(%w[DUPONT])
      expect(fondation).not_to have_key(:beneficiaires_effectifs)
      expect(fondation[:situation_financiere]).to eq(annees_subventions_publiques: [2024, 2025])
    end
  end

  context 'with the beneficial owners scope, granted to public procurement and fraud' do
    let(:scopes) { %w[fondations_mi_siaf fondations_mi_siaf_beneficiaires_effectifs] }

    it 'serves the beneficial owners, including those who left office, but not the control data' do
      call_endpoint

      expect(fondation[:beneficiaires_effectifs].pluck(:nom)).to contain_exactly('DUPONT', 'MARTIN')
      expect(fondation[:situation_financiere].keys).to eq(%i[annees_subventions_publiques])
    end
  end

  context 'with the control scope, granted to fraud only' do
    let(:scopes) { %w[fondations_mi_siaf fondations_mi_siaf_controle] }

    it 'serves the public generosity and foreign financing years but not the beneficial owners' do
      call_endpoint

      expect(fondation).not_to have_key(:beneficiaires_effectifs)
      expect(fondation[:situation_financiere]).to eq(
        annees_subventions_publiques: [2024, 2025],
        annees_appel_generosite_publique: [2024],
        annees_financements_etrangers: [2023]
      )
    end
  end
end
