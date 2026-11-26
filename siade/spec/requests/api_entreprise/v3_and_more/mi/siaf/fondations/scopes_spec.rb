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

  describe 'attachments, filtered on their type as the Ministère de l\'Intérieur opens them per use case' do
    subject(:served_types) do
      call_endpoint
      fondation[:documents].pluck(:type)
    end

    before { stub_siaf_fondation(body: fondation_with_files(foundation_type, all_types)) }

    let(:all_types) do
      [
        'Statuts',
        'Règlement intérieur',
        "Rapport d'activité",
        'Comptes',
        'Procès verbal',
        'Décision administrative',
        'Décision juridictionnelle',
        'Dirigeants',
        'Rubrique ajoutée par le ministère'
      ]
    end

    context 'with the socle scope only, granted from the Dites-le-nous une fois use case' do
      let(:scopes) { %w[fondations_mi_siaf] }

      context 'when the fondation is a FRUP' do
        let(:foundation_type) { 'FRUP' }

        it { is_expected.to eq(['Statuts', 'Règlement intérieur', "Rapport d'activité"]) }
      end

      context 'when the fondation is a fondation d\'entreprise' do
        let(:foundation_type) { 'FE' }

        it { is_expected.to eq(['Statuts', "Rapport d'activité"]) }
      end

      context 'when the fondation is a fonds de dotation' do
        let(:foundation_type) { 'FDD' }

        it { is_expected.to eq(['Statuts']) }
      end
    end

    context 'with the accounts scope, granted to public subsidies, public procurement and fraud' do
      let(:scopes) { %w[fondations_mi_siaf fondations_mi_siaf_comptes] }

      context 'when the fondation is a fonds de dotation' do
        let(:foundation_type) { 'FDD' }

        it 'serves its accounts and activity report too, but neither its internal rules nor the minutes' do
          expect(served_types).to eq(['Statuts', "Rapport d'activité", 'Comptes'])
        end
      end

      context 'when the fondation is a FRUP' do
        let(:foundation_type) { 'FRUP' }

        it { is_expected.to eq(['Statuts', 'Règlement intérieur', "Rapport d'activité", 'Comptes']) }
      end

      context 'when the fondation is a fondation d\'entreprise' do
        let(:foundation_type) { 'FE' }

        it 'serves its accounts too, but not its internal rules' do
          expect(served_types).to eq(['Statuts', "Rapport d'activité", 'Comptes'])
        end
      end
    end

    context 'with the control scope, granted to fraud only' do
      let(:scopes) { %w[fondations_mi_siaf fondations_mi_siaf_comptes fondations_mi_siaf_controle] }
      let(:foundation_type) { 'FDD' }

      it 'serves every attachment, minutes, decisions and types unknown to the API included' do
        expect(served_types).to eq(all_types)
      end
    end

    context 'when the fondation type is unknown to the API' do
      let(:scopes) { %w[fondations_mi_siaf fondations_mi_siaf_comptes] }
      let(:foundation_type) { 'Nouveau type' }

      it { is_expected.to be_empty }
    end

    describe 'a served attachment' do
      subject(:document) do
        call_endpoint
        fondation[:documents].first
      end

      let(:scopes) { %w[fondations_mi_siaf] }
      let(:foundation_type) { 'FRUP' }
      let(:all_types) { %w[Statuts] }

      it 'gives its metadata and a download link carrying neither the token nor the file id in clear' do
        expect(document).to include(
          id: 'file-0',
          type: 'Statuts',
          nom_original: 'PV conseil 2024.pdf',
          type_mime: 'application/pdf',
          taille: 120_000,
          date_effet: '2024-03-12',
          date_depot: '2026-07-22'
        )
        expect(document).not_to have_key(:scope)
        expect(document[:url]).to start_with('http://test.entreprise.api.gouv.fr/proxy/siaf/fondations/download/')
        expect(document[:url]).not_to include('file-0')
      end
    end
  end

  def fondation_with_files(foundation_type, type_files)
    payload = JSON.parse(read_payload_file('mi/siaf/fondations/valid.json'))
    file = payload['files'].first

    payload.merge(
      'foundationType' => foundation_type,
      'files' => type_files.each_with_index.map { |type_file, index| file.merge('id' => "file-#{index}", 'typeFile' => type_file) }
    ).to_json
  end
end
