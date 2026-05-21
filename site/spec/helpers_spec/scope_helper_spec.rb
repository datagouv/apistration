require 'rails_helper'

RSpec.describe ScopeHelper do
  include described_class

  describe '#humanize_scope' do
    it 'returns the I18n label for a known scope' do
      expect(humanize_scope('unites_legales_etablissements_insee', 'entreprise'))
        .to eq('INSEE || API Données unités légales et établissements dont les non diffusibles')
    end

    it 'falls back to scope.humanize when no I18n label is defined' do
      expect(humanize_scope('totally_unknown_scope', 'entreprise'))
        .to eq('Totally unknown scope')
    end
  end

  describe '#build_scopes' do
    it 'returns correct tree structure for cnaf_quotient_familial scope' do
      scopes = ['cnaf_quotient_familial']

      result = build_scopes(scopes, 'particulier')

      expect(result).to eq({
        'CNAF & MSA' => {
          'API Quotient familial' => ['QF']
        }
      })
    end

    it 'doesnt fail when same provider has mixed scope label lengths' do
      scopes = %w[pole_emploi_identite pole_emploi_paiements]

      result = build_scopes(scopes, 'particulier')

      expect(result).to eq({
        'France Travail' => {
          "API statut demandeur d'emploi" => ['Statut et identité du demandeur'],
          'API paiements France Travail' => []
        }
      })
    end
  end
end
