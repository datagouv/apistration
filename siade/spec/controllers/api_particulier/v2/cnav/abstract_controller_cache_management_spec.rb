RSpec.describe APIParticulier::V2::CNAV::AbstractController, 'cache management' do
  subject(:call!) do
    routes.draw { get 'show' => 'api_particulier/v2/cnav/abstract#show' }

    get :show, params:
  end

  let(:token) { yes_jwt }

  context 'with valid params' do
    controller(described_class) do
      protected

      def operation_id
        'api_particulier_v2_cnav_quotient_familial_v2'
      end

      def retriever
        CNAV::QuotientFamilialV2
      end

      def user_identity_params
        super.merge({
          annee: params[:annee],
          mois: params[:mois]
        })
      end

      def expires_in
        24.hours
      end

      def serializer_class
        APIParticulier::CNAF::QuotientFamilial::V2
      end
    end

    let(:recipient) { '13002526500013' }
    let(:params) do
      {
        nomNaissance: 'CHAMPION',
        'prenoms[]': 'JEAN-PASCAL',
        anneeDateDeNaissance: 1980,
        moisDateDeNaissance: 6,
        jourDateDeNaissance: 12,
        sexe: 'M',
        codePaysLieuDeNaissance: '99100',
        codeInseeLieuDeNaissance: '17300',
        annee: 2024,
        mois: 12,
        token:
      }
    end

    let(:organizer_params) do
      {
        nom_usage: nil,
        nom_naissance: 'CHAMPION',
        prenoms: ['JEAN-PASCAL'],
        annee_date_naissance: '1980',
        mois_date_naissance: '6',
        jour_date_naissance: '12',
        code_cog_insee_pays_naissance: '99100',
        sexe_etat_civil: 'M',
        code_cog_insee_commune_naissance: '17300',
        code_cog_insee_departement_naissance: nil,
        nom_commune_naissance: nil,
        annee: '2024',
        mois: '12'
      }
    end

    before do
      stub_cnav_authenticate('quotient_familial_v2')
      stub_cnav_valid('allocation_soutien_familial', siret: recipient)
    end

    context 'when cache is activated' do
      context 'when Cache-Control: no-cache request header is present' do
        before do
          request.headers['Cache-Control'] = 'no-cache'
        end

        it 'does not call CacheResourceRetriever' do
          expect(CacheResourceRetriever).not_to receive(:call)

          subject
        end

        it 'renders X-Response-cached header as false, and an empty X-Cache-Expires-in' do
          subject

          expect(response.headers['X-Response-Cached']).to be(false)
          expect(response.headers['X-Cache-Expires-in']).to eq('')
        end

        it 'adds custom field retriever_cached as false on LogStasher' do
          expect(LogStasher).to receive(:build_logstash_event).with(
            hash_including(
              retriever_cached: false
            ),
            anything
          )

          subject
        end

        it 'calls the retriever with parameters and operation id' do
          expect(CNAV::QuotientFamilialV2)
            .to receive(:call)
            .with({
              params: hash_including(organizer_params),
              operation_id: 'api_particulier_v2_cnav_quotient_familial_v2',
              recipient: '13002526500013'
            }).and_call_original

          subject
        end
      end

      context 'without the Cache-Control: no-cache request header' do
        # rubocop:disable RSpec/VerifiedDoubles
        let(:cache_resource_retriever) do
          double(
            'cache_resource_retriever',
            from_cache: true,
            expires_in: 9001,
            success?: true,
            mocked_data: {},
            errors: [],
            bundled_data: BundledData.new(
              data: Resource.new(
                allocataires: [
                  {
                    nomNaissance: 'CHAMPION',
                    nomUsuel: 'DU MONDE',
                    prenoms: 'JEAN-PASCAL ROMAIN',
                    anneeDateDeNaissance: '1980',
                    moisDateDeNaissance: '06',
                    jourDateDeNaissance: '12',
                    sexe: 'M'
                  },
                  {
                    nomNaissance: 'NIDOUILLET',
                    nomUsuel: nil,
                    prenoms: 'JOSIANE',
                    anneeDateDeNaissance: '1981',
                    moisDateDeNaissance: '05',
                    jourDateDeNaissance: '02',
                    sexe: 'F'
                  }
                ],
                enfants: [],
                adresse:
                {
                  identite: 'DU MONDE JEAN-PASCAL',
                  complementInformation: 'APPARTEMENT 2',
                  complementInformationGeographique: nil,
                  numeroLibelleVoie: nil,
                  lieuDit: nil,
                  codePostalVille: '81700 GARREVAQUES',
                  pays: 'FRANCE'
                },
                regime: 'CNAF',
                quotientFamilial: 464,
                annee: 2023,
                mois: 6,
                annee_calcul: 2021,
                mois_calcul: 3
              )
            )
          )
        end
        # rubocop:enable RSpec/VerifiedDoubles

        before do
          allow(CacheResourceRetriever).to receive_messages(call: cache_resource_retriever)
        end

        it 'renders X-Response-cached header as true, with X-Cache-Expires-in sets as an integer' do
          subject

          expect(response.headers['X-Response-Cached']).to be(true)
          expect(response.headers['X-Cache-Expires-in']).to eq(9001)
        end

        it 'adds custom field retriever_cached as true on LogStasher' do
          expect(LogStasher).to receive(:build_logstash_event).with(
            hash_including(
              retriever_cached: true
            ),
            anything
          )

          subject
        end

        it 'calls CacheResourceRetriever with parameters' do
          expect(CacheResourceRetriever)
            .to receive(:call)
            .with({
              retriever_organizer: CNAV::QuotientFamilialV2,
              retriever_params: {
                params: hash_including(organizer_params),
                operation_id: 'api_particulier_v2_cnav_quotient_familial_v2',
                recipient: '13002526500013'
              },
              cache_key: "/show:#{organizer_params.to_query}",
              expires_in: 24.hours
            })

          subject
        end
      end
    end
  end
end
