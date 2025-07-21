RSpec.describe INPI::RNE::ExtraitRNE::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(params:, response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:url_regexp) { %r{^http://test\.entreprise\.api\.gouv\.fr/proxy/inpi/download/\S*$} }

  let(:params) do
    {
      siren: valid_siren(:inpi),
      token_id: 'token-id'
    }
  end

  let(:body) { read_payload_file('inpi/rne/extrait_rne/valid.json') }

  before(:all) do
    Timecop.freeze
  end

  after(:all) do
    Timecop.return
  end

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    context 'with valid.json' do
      it do
        expect(subject[:document_url]).to match(url_regexp)
        expect(subject).to include(
          {
            identite_entreprise: {
              siren: '123456789',
              denomination: nil,
              nom: 'DUPONT',
              prenoms: %w[JEAN PIERRE],
              forme_juridique: {
                code: '1000',
                libelle: 'Entreprise individuelle'
              },
              nature_entreprise: 'ARTISANALE',
              associe_unique: false,
              date_immatriculation_rne: '2010-01-01',
              date_debut_activite: nil,
              date_fin_personne: nil,
              date_cloture_exercice: nil,
              date_premiere_cloture_exercice: nil,
              detail_cessation: nil,
              dissolution: {
                date: nil,
                poursuite_activite: false,
                avec_liquidation: nil
              },
              capital_social: {
                montant: nil,
                devise: 'EUR'
              },
              activite_principales_objet_social: 'Fabrication d\'articles de bijouterie fantaisie et articles similaires',
              code_APE: {
                code: '3213Z',
                libelle: 'Fabrication d\'articles de bijouterie fantaisie et articles similaires'
              },
              code_APRM: {
                code: nil,
                libelle: nil
              },
              adresse_siege_social: {
                voie: '10 RUE DE LA PAIX',
                code_postal: '75001',
                commune: 'PARIS',
                pays: 'FRANCE',
                complement: nil
              }
            },
            dirigeants_et_associes: [],
            etablissements: [
              {
                siret: '12345678900001',
                type_etablissement: 'Siège et principal',
                statut: 'actif',
                date_debut_activite: '2010-01-15',
                code_APE: {
                  code: '3213Z',
                  libelle: 'Fabrication d\'articles de bijouterie fantaisie et articles similaires'
                },
                code_APRM: {
                  code: nil,
                  libelle: nil
                },
                origine_fonds: 'Création',
                nature_etablissement: 'ARTISANALE',
                activite_principale: 'FABRICATION D\'ARTICLES DIVERS',
                autre_activite: nil,
                adresse: {
                  voie: '10 RUE DE LA PAIX',
                  code_postal: '75001',
                  commune: 'PARIS',
                  pays: 'FRANCE',
                  complement: nil
                }
              }
            ],
            diffusion_commerciale: false,
            diffusion_insee: false,
            etablissements_fermes_total: 0,
            observations: []
          }
        )
      end
    end

    context 'with valid_rcs_with_observations.json' do
      let(:body) { read_payload_file('inpi/rne/extrait_rne/valid_rcs_with_observations.json') }

      it do
        expect(subject[:document_url]).to match(url_regexp)
        expect(subject).to include(
          {
            identite_entreprise: {
              siren: '987654321',
              denomination: 'SOCIETE TEST',
              nom: nil,
              prenoms: nil,
              forme_juridique: {
                code: '5710',
                libelle: 'SAS, société par actions simplifiée'
              },
              date_immatriculation_rne: '2020-01-15',
              date_debut_activite: '2020-01-15',
              date_fin_personne: '2119-01-14',
              date_cloture_exercice: '12-31',
              date_premiere_cloture_exercice: '2021-12-31',
              detail_cessation: nil,
              dissolution: {
                date: nil,
                poursuite_activite: false,
                avec_liquidation: nil
              },
              nature_entreprise: 'COMMERCIALE',
              associe_unique: false,
              capital_social: {
                montant: 1000.0,
                devise: 'EUR'
              },
              activite_principales_objet_social: 'Activités des sièges sociaux et conseil en gestion d\'entreprise.',
              code_APE: {
                code: '7010Z',
                libelle: 'Activités des sièges sociaux'
              },
              code_APRM: {
                code: nil,
                libelle: nil
              },
              adresse_siege_social: {
                voie: '100 AV DES CHAMPS ELYSEES',
                code_postal: '75008',
                commune: 'PARIS',
                pays: 'FRANCE',
                complement: nil
              }
            },
            dirigeants_et_associes: [
              {
                qualite: 'PRESIDENT',
                nom: 'DURAND',
                prenom: 'MARIE',
                date_naissance: '05/1975',
                commune_residence: 'PARIS'
              },
              {
                qualite: 'DIRECTEUR GENERAL',
                nom: 'BERNARD',
                prenom: 'PIERRE',
                date_naissance: '01/1990',
                commune_residence: 'PARIS'
              }
            ],
            etablissements: [
              {
                siret: '98765432100015',
                type_etablissement: 'Siège et principal',
                statut: 'actif',
                date_debut_activite: '2020-01-15',
                code_APE: {
                  code: '7010Z',
                  libelle: 'Activités des sièges sociaux'
                },
                code_APRM: {
                  code: nil,
                  libelle: nil
                },
                origine_fonds: 'Création',
                nature_etablissement: 'COMMERCIALE',
                activite_principale: 'Activités des sièges sociaux et conseil en gestion d\'entreprise.',
                autre_activite: nil,
                adresse: {
                  voie: '100 AV DES CHAMPS ELYSEES',
                  code_postal: '75008',
                  commune: 'PARIS',
                  pays: 'FRANCE',
                  complement: nil
                }
              }
            ],
            diffusion_commerciale: true,
            diffusion_insee: true,
            etablissements_fermes_total: 0,
            observations: [
              {
                fournisseur: 'rcs',
                numero: '2020A123456',
                date: '2020-01-15',
                texte: 'Constitution de la société'
              }
            ]
          }
        )
      end
    end

    context 'with valid_rnm_with_observations.json' do
      let(:body) { read_payload_file('inpi/rne/extrait_rne/valid_rnm_with_observations.json') }

      it do
        expect(subject[:document_url]).to match(url_regexp)
        expect(subject).to include(
          {
            identite_entreprise: {
              siren: '123456789',
              denomination: nil,
              nom: 'DUPONT',
              prenoms: %w[JEAN MARIE],
              forme_juridique: {
                code: '1000',
                libelle: 'Entreprise individuelle'
              },
              nature_entreprise: 'INDEPENDANTE',
              associe_unique: false,
              date_immatriculation_rne: '2024-01-01',
              date_debut_activite: nil,
              date_fin_personne: nil,
              date_cloture_exercice: nil,
              date_premiere_cloture_exercice: nil,
              detail_cessation: nil,
              dissolution: {
                date: nil,
                poursuite_activite: false,
                avec_liquidation: nil
              },
              capital_social: {
                montant: nil,
                devise: 'EUR'
              },
              activite_principales_objet_social: 'Entretien et réparation de véhicules automobiles légers',
              code_APE: {
                code: '4520A',
                libelle: 'Entretien et réparation de véhicules automobiles légers'
              },
              code_APRM: {
                code: nil,
                libelle: nil
              },
              adresse_siege_social: {
                voie: '10 RUE DE LA PAIX',
                code_postal: '75001',
                commune: 'PARIS',
                pays: 'FRANCE',
                complement: nil
              }
            },
            dirigeants_et_associes: [],
            etablissements: [
              {
                siret: '12345678900010',
                type_etablissement: 'Siège et principal',
                statut: 'actif',
                date_debut_activite: '2024-01-01',
                code_APE: {
                  code: '4520A',
                  libelle: 'Entretien et réparation de véhicules automobiles légers'
                },
                code_APRM: {
                  code: nil,
                  libelle: nil
                },
                origine_fonds: 'Création',
                nature_etablissement: 'INDEPENDANTE',
                activite_principale: 'reparation automobile et entretien vehicules',
                autre_activite: nil,
                adresse: {
                  voie: '10 RUE DE LA PAIX',
                  code_postal: '75001',
                  commune: 'PARIS',
                  pays: 'FRANCE',
                  complement: nil
                }
              }
            ],
            diffusion_commerciale: true,
            diffusion_insee: true,
            etablissements_fermes_total: 0,
            observations: [
              {
                fournisseur: 'rnm',
                numero: nil,
                date: '2024-06-15',
                texte: 'Inscription d\'office de mentions - Qualité de la personne - Artisan - JEAN DUPONT (Entrepreneur) - Établissement - 12345678900010 - Entretien et réparation de véhicules automobiles'
              },
              {
                fournisseur: 'rnm',
                numero: nil,
                date: '2024-09-20',
                texte: 'Modification relative au conjoint collaborateur'
              }
            ]
          }
        )
      end
    end

    context 'with valid_ei.json' do
      let(:body) { read_payload_file('inpi/rne/extrait_rne/valid_ei.json') }

      it do
        expect(subject[:document_url]).to match(url_regexp)
        expect(subject).to include(
          {
            identite_entreprise: {
              siren: '123456789',
              denomination: nil,
              nom: 'MARTIN',
              prenoms: %w[JEAN PIERRE HENRI],
              forme_juridique: {
                code: '1000',
                libelle: 'Entreprise individuelle'
              },
              nature_entreprise: 'LIBERALE_NON_REGLEMENTEE',
              associe_unique: false,
              date_immatriculation_rne: '2020-01-01',
              date_debut_activite: '2020-01-07',
              date_fin_personne: nil,
              date_cloture_exercice: nil,
              date_premiere_cloture_exercice: nil,
              detail_cessation: nil,
              dissolution: {
                date: nil,
                poursuite_activite: false,
                avec_liquidation: nil
              },
              capital_social: {
                montant: nil,
                devise: 'EUR'
              },
              activite_principales_objet_social: 'Programmation informatique',
              code_APE: {
                code: '6201Z',
                libelle: 'Programmation informatique'
              },
              code_APRM: {
                code: nil,
                libelle: nil
              },
              adresse_siege_social: {
                voie: '10 RUE DE LA PAIX',
                code_postal: '75001',
                commune: 'PARIS',
                pays: 'FRANCE',
                complement: nil
              }
            },
            dirigeants_et_associes: [],
            etablissements: [
              {
                siret: '12345678900001',
                type_etablissement: 'Siège et principal',
                date_debut_activite: '2020-01-07',
                code_APE: {
                  code: '6201Z',
                  libelle: 'Programmation informatique'
                },
                code_APRM: {
                  code: nil,
                  libelle: nil
                },
                origine_fonds: 'Création',
                nature_etablissement: 'LIBERALE_NON_REGLEMENTEE',
                activite_principale: 'Programmation informatique',
                autre_activite: nil,
                adresse: {
                  voie: '10 RUE DE LA PAIX',
                  code_postal: '75001',
                  commune: 'PARIS',
                  pays: 'FRANCE',
                  complement: nil
                },
                statut: 'actif'
              },
              {
                siret: '12345678900002',
                type_etablissement: 'Secondaire',
                date_debut_activite: '2020-01-01',
                code_APE: {
                  code: '6201Z',
                  libelle: 'Programmation informatique'
                },
                code_APRM: {
                  code: nil,
                  libelle: nil
                },
                origine_fonds: 'Création',
                nature_etablissement: 'LIBERALE_NON_REGLEMENTEE',
                activite_principale: 'Programmation informatique',
                autre_activite: nil,
                adresse: {
                  voie: '5 DES HALLES',
                  code_postal: '69001',
                  commune: 'LYON',
                  pays: 'FRANCE',
                  complement: nil
                },
                statut: 'fermé'
              }
            ],
            diffusion_commerciale: true,
            diffusion_insee: false,
            etablissements_fermes_total: 1,
            observations: []
          }
        )
      end
    end
  end
end
