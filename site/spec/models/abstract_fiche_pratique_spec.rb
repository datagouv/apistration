# frozen_string_literal: true

RSpec.describe AbstractFichePratique do
  describe '.all' do
    it 'loads API Entreprise fiches pratiques from i18n' do
      expect(APIEntreprise::FichePratique.all.map(&:uid)).to include('socle_de_base')
    end

    it 'loads API Particulier fiches pratiques from i18n' do
      expect(APIParticulier::FichePratique.all.map(&:uid)).to include('modalite_appel_france_connect')
    end
  end
end
