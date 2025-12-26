RSpec.describe GIPMDS::ServiceCivique::BuildResource, type: :build_resource do
  subject(:instance) { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

  describe 'with a current contract (no end date)' do
    let(:body) { read_payload_file('gip_mds/service_civique/valid.json') }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      it do
        expect(subject).to eq(
          {
            statut_actuel: {
              contrat_trouve: true,
              organisme_accueil: {
                siret: '13002526500013',
                raison_sociale: 'DIRECTION INTERMINISTERIELLE DU NUMERIQUE'
              },
              date_debut_contrat: '2024-01-15',
              date_fin_contrat: nil
            },
            statut_passe: {
              contrat_trouve: false,
              organisme_accueil: nil,
              date_debut_contrat: nil,
              date_fin_contrat: nil
            }
          }
        )
      end
    end
  end

  describe 'with a current contract (motifRupture 99)' do
    let(:body) { read_payload_file('gip_mds/service_civique/valid_motif_rupture_99.json') }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      it 'treats as current contract' do
        expect(subject[:statut_actuel][:contrat_trouve]).to be true
        expect(subject[:statut_passe][:contrat_trouve]).to be false
      end
    end
  end

  describe 'with a current contract (motifRupture 100)' do
    let(:body) { read_payload_file('gip_mds/service_civique/valid_motif_rupture_100.json') }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      it 'treats as current contract' do
        expect(subject[:statut_actuel][:contrat_trouve]).to be true
        expect(subject[:statut_passe][:contrat_trouve]).to be false
      end
    end
  end

  describe 'with a past contract' do
    let(:body) { read_payload_file('gip_mds/service_civique/past_contract.json') }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      it do
        expect(subject).to eq(
          {
            statut_actuel: {
              contrat_trouve: false,
              organisme_accueil: nil,
              date_debut_contrat: nil,
              date_fin_contrat: nil
            },
            statut_passe: {
              contrat_trouve: true,
              organisme_accueil: {
                siret: '13002526500013',
                raison_sociale: 'DIRECTION INTERMINISTERIELLE DU NUMERIQUE'
              },
              date_debut_contrat: '2023-01-15',
              date_fin_contrat: '2023-07-14'
            }
          }
        )
      end
    end
  end

  describe 'with no contract (NOT_FOUND_CONTRAT case)' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404', body:) }
    let(:body) { read_payload_file('gip_mds/service_civique/not_found_contrat.json') }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      it do
        expect(subject).to eq(
          {
            statut_actuel: {
              contrat_trouve: false,
              organisme_accueil: nil,
              date_debut_contrat: nil,
              date_fin_contrat: nil
            },
            statut_passe: {
              contrat_trouve: false,
              organisme_accueil: nil,
              date_debut_contrat: nil,
              date_fin_contrat: nil
            }
          }
        )
      end
    end
  end
end
