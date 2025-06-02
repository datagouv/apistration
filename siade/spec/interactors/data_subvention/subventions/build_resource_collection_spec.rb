RSpec.describe DataSubvention::Subventions::BuildResourceCollection, type: :build_resource do
  subject { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:body) do
    DataSubvention::Subventions::MakeRequest.call(params:, token:).response.body
  end

  let(:params) do
    {
      siren_or_siret_or_rna: siren
    }
  end

  let(:token) { 'data_subvention_token' }

  let(:siren) { valid_siren }

  let(:valid_collection) do
    [
      {
        demande_subvention: {
          fournisseur: 'OSIRIS',
          date_mise_a_jour_information: '2019-01-01T00:00:00.000Z',
          annee_exercice_demande: 2019,
          identifiant_engagement_juridique: '19/0003456',
          subvention_demandee: {
            dispositif: 'ANS - Projets Sportifs Territoriaux',
            sous_dispositif: 'Aides territoriales (hors emploi)',
            montant_demande: 2000
          },
          description_des_projets: {
            estimation_cout_total: 8500,
            projet: [
              {
                rang: 1,
                intitule: 'Développement du football féminin dans les établissements scolaires',
                objectifs: 'Promouvoir la pratique du football féminin auprès des jeunes filles de 8 à 16 ans dans les écoles primaires et collèges du territoire. Organiser des tournois inter-établissements et former des équipes compétitives.',
                objectifs_operationnels: 'Développement de la pratique',
                description: "Le projet consiste à intervenir dans 8 établissements scolaires du territoire avec des séances d'initiation et de perfectionnement au football féminin. Chaque établissement bénéficiera de 10 séances de 2 heures, encadrées par notre éducatrice diplômée. Le matériel pédagogique (ballons, cônes, chasubles) sera fourni par le club.",
                aide: {
                  nature: 'Projets sportifs territoriaux',
                  modalite: 'Aide au projet'
                },
                modalite_ou_dispositif: 'Développer la pratique féminine',
                indicateurs: nil,
                cofinanceurs: 'Conseil départemental du Nord;Ville de Lille;Métropole Européenne de Lille;'
              }
            ]
          },
          instruction: {
            service_instructeur: 'DD59',
            date_commission: '2019-06-15T00:00:00.000Z',
            statut_demande: 'Accordé',
            montant_accorde: 1800
          }
        },
        paiements: []
      },
      {
        demande_subvention: {
          fournisseur: 'OSIRIS',
          date_mise_a_jour_information: '2020-01-01T00:00:00.000Z',
          annee_exercice_demande: 2020,
          identifiant_engagement_juridique: '20/0008765',
          subvention_demandee: {
            dispositif: 'ANS - Projets Sportifs Fédéraux',
            sous_dispositif: 'Projets sportifs fédéraux',
            montant_demande: 3500
          },
          description_des_projets: {
            estimation_cout_total: 12_400,
            projet: []
          },
          instruction: {
            service_instructeur: 'FFTEN-IDF',
            date_commission: '2020-09-14T00:00:00.000Z',
            statut_demande: 'Accordé',
            montant_accorde: 2800
          }
        },
        paiements: []
      },
      {
        demande_subvention: nil,
        paiements: [
          {
            fournisseur: 'Chorus',
            date_mise_a_jour_information: '2021-03-15T00:00:00.000Z',
            montant_verse: 1250,
            date_versement: '2021-03-15T00:00:00.000Z',
            centre_financier: 'UO Region BFC-FC',
            domaine_fonctionnel: 'sport handicap',
            activitee: 'handisport',
            programme: {
              numero: '219',
              libelle: 'Sport',
              numero_bop: '219'
            }
          }
        ]
      },
      {
        demande_subvention: {
          fournisseur: 'OSIRIS',
          date_mise_a_jour_information: '2022-01-01T00:00:00.000Z',
          annee_exercice_demande: 2022,
          identifiant_engagement_juridique: nil,
          subvention_demandee: {
            dispositif: "Pass'Sport",
            sous_dispositif: "Pass'Sport",
            montant_demande: 300
          },
          description_des_projets: {
            estimation_cout_total: 0,
            projet: []
          },
          instruction: {
            service_instructeur: 'DR-PACA',
            date_commission: nil,
            statut_demande: 'En instruction',
            montant_accorde: 0
          }
        },
        paiements: []
      },
      {
        demande_subvention: {
          fournisseur: 'OSIRIS',
          date_mise_a_jour_information: '2023-01-01T00:00:00.000Z',
          annee_exercice_demande: 2023,
          identifiant_engagement_juridique: '23/0015789',
          subvention_demandee: {
            dispositif: 'ANS - Projets Sportifs Territoriaux - Professionnalisation',
            sous_dispositif: 'Emploi',
            montant_demande: 12_000
          },
          description_des_projets: {
            estimation_cout_total: 45_600,
            projet: [
              {
                rang: 1,
                intitule: "Création d'un poste d'éducateur territorial pour le développement du basket en milieu rural",
                objectifs: "Créer un emploi pérenne d'éducateur sportif pour développer la pratique du basket-ball dans les communes rurales du département. Mettre en place des cycles d'initiation dans les écoles et centres de loisirs.",
                objectifs_operationnels: 'Développement de la pratique',
                description: "Le poste créé permettra d'intervenir dans un rayon de 40 km autour de Lyon, dans les zones rurales déficitaires en animation sportive. L'éducateur proposera des initiations au basket dans 15 communes partenaires, avec un focus sur les publics jeunes et les personnes éloignées de la pratique sportive.",
                aide: {
                  nature: "Aide à l'emploi",
                  modalite: 'Emploi Agence du Sport'
                },
                modalite_ou_dispositif: "Diversification de l'offre de pratique",
                indicateurs: nil,
                cofinanceurs: 'Conseil départemental du Rhône;Métropole de Lyon;Agence de services et de paiement;'
              }
            ]
          },
          instruction: {
            service_instructeur: 'DD69',
            date_commission: '2023-04-20T00:00:00.000Z',
            statut_demande: 'Accordé',
            montant_accorde: 9500
          }
        },
        paiements: []
      }
    ]
  end

  before do
    stub_datasubvention_subventions_valid(id: siren)
  end

  context 'when the request is successful' do
    it { is_expected.to be_a_success }

    it 'builds valid resources' do
      expect(subject.bundled_data.data).to all be_a(Resource)
    end

    it 'has valid resource_collection' do
      expect(subject.bundled_data.data.map(&:to_h)).to eq(valid_collection)
    end
  end
end
