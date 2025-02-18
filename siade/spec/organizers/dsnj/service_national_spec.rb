RSpec.describe DSNJ::ServiceNational, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      nom_naissance:,
      prenoms:,
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:,
      code_cog_insee_commune_naissance:,
      code_cog_insee_pays_naissance:,
      sexe_etat_civil:
    }
  end

  let(:nom_naissance) { 'Sekiro' }
  let(:prenoms) { %w[Shinobi Wolf] }
  let(:annee_date_naissance) { 1988 }
  let(:mois_date_naissance) { 3 }
  let(:jour_date_naissance) { 22 }
  let(:code_cog_insee_commune_naissance) { '92036' }
  let(:code_cog_insee_pays_naissance) { '99100' }
  let(:sexe_etat_civil) { 'M' }

  describe 'valid params' do
    pending 'Implement endpoint'
  end
end
