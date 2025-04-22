RSpec.describe CNAV::ParticipationFamilialeEAJE, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:common_params) do
    {
      nom_naissance: 'CHAMPION',
      prenoms: ['JEAN-PASCAL'],
      annee_date_naissance: 1980,
      mois_date_naissance: 6,
      jour_date_naissance: 12,
      sexe_etat_civil: 'M',
      code_cog_insee_pays_naissance: '99100',
      request_id:,
      recipient:
    }
  end

  describe 'valid params' do
    pending 'Implement Endpoint'
  end
end
