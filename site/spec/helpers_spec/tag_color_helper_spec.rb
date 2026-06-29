require 'rails_helper'

RSpec.describe TagColorHelper do
  include described_class

  describe '#administration_badge_color' do
    it 'returns the mapped DSFR color for a known label' do
      expect(administration_badge_color('Tous les acteurs publics')).to eq('beige-gris-galet')
    end

    it 'falls back to pink-tuile for an unknown label' do
      expect(administration_badge_color('Label inexistant')).to eq('pink-tuile')
    end
  end

  describe 'ADMINISTRATION_COLORS coverage' do
    it 'maps every user_type declared in fiches pratiques locales' do
      user_types = [APIEntreprise::FichePratique, APIParticulier::FichePratique]
        .flat_map(&:all)
        .flat_map { |fiche| fiche.user_types.to_a }
        .uniq

      missing = user_types.reject { |label| described_class::ADMINISTRATION_COLORS.key?(label) }

      expect(missing).to be_empty,
        "Fiches pratiques user_types without an explicit badge color:\n" \
        "#{missing.map { |label| "  #{label}" }.join("\n")}\n" \
        'Add them to TagColorHelper::ADMINISTRATION_COLORS.'
    end

    it 'maps every Fournisseurs_de_services label declared in Grist' do
      labels = grist_fournisseurs_labels
      skip 'Grist unreachable' if labels.nil?

      missing = labels.reject { |label| described_class::ADMINISTRATION_COLORS.key?(label) }

      expect(missing).to be_empty,
        "Grist Fournisseurs_de_services labels without an explicit badge color:\n" \
        "#{missing.map { |label| "  #{label}" }.join("\n")}\n" \
        'Add them to TagColorHelper::ADMINISTRATION_COLORS ' \
        '(watch out for typographic apostrophes ’ vs straight \').'
    end
  end

  def grist_fournisseurs_labels
    WebMock.allow_net_connect!
    url = "#{Simplifions::GristClient::GRIST_BASE_URL}/Fournisseurs_de_services/records"
    response = Faraday.get(url) { |req| req.options.timeout = 5 }

    JSON.parse(response.body).fetch('records', []).filter_map { |record| record.dig('fields', 'Label') }
  rescue StandardError
    nil
  ensure
    WebMock.disable_net_connect!(allow_localhost: true)
  end
end
