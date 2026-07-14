require 'rails_helper'

RSpec.describe Datagouv::FichePayloadBuilder do
  subject(:payload) { described_class.new(endpoint).payload }

  context 'with a protected API Entreprise endpoint that has a throttle entry' do
    let(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }

    it 'builds the full payload' do
      expect(payload).to eq(
        access_type: 'restricted',
        base_api_url: 'https://entreprise.api.gouv.fr',
        business_documentation_url: 'https://entreprise.api.gouv.fr/catalogue/inpi/rne/beneficiaires_effectifs',
        technical_documentation_url: 'https://entreprise.api.gouv.fr/developpeurs/openapi#tag/Informations-generales/paths/~1v3~1inpi~1rne~1unites_legales~1%7Bsiren%7D~1beneficiaires_effectifs/get',
        machine_documentation_url: 'https://entreprise.api.gouv.fr/open-api-without-deprecated-paths.yml',
        authorization_request_url: 'https://datapass.api.gouv.fr/api-entreprise',
        title: 'API Bénéficiaires effectifs - INPI | Bouquet API Entreprise',
        description: <<~MARKDOWN,
          > L'[API Bénéficiaires effectifs - INPI | Bouquet API Entreprise](https://entreprise.api.gouv.fr/catalogue/inpi/rne/beneficiaires_effectifs) permet d'obtenir les informations suivantes : **Liste des bénéficiaires effectifs d'une unité légale inscrite au répertoire national des entreprises (RNE)**.

          ➡️ **Cette API fait partie du bouquet [API Entreprise](https://entreprise.api.gouv.fr/catalogue)** opéré par la direction interministérielle du numérique (DINUM). Ces données et l'API source proviennent de INPI.

          - 🔐 **Uniquement accessible aux administrations et collectivités**.
          - ☎️ **Modalité d'appel** : SIREN.
          - 📖 **[Documentation métier](https://entreprise.api.gouv.fr/catalogue/inpi/rne/beneficiaires_effectifs)**
          - 📟 **[Documentation technique (swagger)](https://entreprise.api.gouv.fr/developpeurs/openapi#tag/Informations-generales/paths/~1v3~1inpi~1rne~1unites_legales~1%7Bsiren%7D~1beneficiaires_effectifs/get)**
        MARKDOWN
        tags: %w[administration administration-et-legislation api-entreprise beneficiaire droit-de-vote indivision inpi nue-propriete part patrimoine propriete rcs repartition representant-legal rne rnm titulaire usufruit],
        rate_limiting: '15 requêtes / minute'
      )
    end
  end

  context 'with a public API Entreprise endpoint' do
    let(:endpoint) { APIEntreprise::Endpoint.find('dgfip/numero_tva') }

    it 'maps opening: public to access_type: open' do
      expect(payload[:access_type]).to eq('open')
    end

    it 'renders the open access line in the description' do
      expect(payload[:description]).to include('- ✅ **Accessible à tous**.')
    end

    it 'includes a rate_limiting derived from the throttle entry' do
      expect(payload[:rate_limiting]).to eq('250 requêtes / minute')
    end

    it 'includes the base api-entreprise tags plus provider and keyword tags' do
      expect(payload[:tags]).to eq(%w[administration administration-et-legislation api-entreprise dgfip intracommunautaire numero-tva])
    end
  end

  context 'with an endpoint whose swagger description ends in an ellipsis' do
    let(:endpoint) { APIEntreprise::Endpoint.find('ministere_interieur/documents_associations') }

    it 'strips all trailing periods so the punchline does not end with a double-dot' do
      expect(payload[:description]).to include(
        '**Divers documents administratifs en PDF tels que les statuts, le récépissé de déclaration de création, la liste des dirigeants**.'
      )
      expect(payload[:description]).not_to include('..**')
    end
  end

  context 'with an endpoint whose keywords attribute is entirely absent (nil)' do
    let(:endpoint) { APIEntreprise::Endpoint.find('ministere_interieur/rna') }

    it 'builds tags from the base set and provider_uids only, without raising' do
      expect(payload[:tags]).to eq(%w[administration administration-et-legislation api-entreprise mi])
    end
  end

  context 'with an API Particulier endpoint whose call_id is an array' do
    let(:endpoint) { APIParticulier::Endpoint.find('education_nationale/statut_eleve_scolarise') }

    it 'uses the particulier base_api_url and display name' do
      expect(payload[:base_api_url]).to eq('https://particulier.api.gouv.fr')
      expect(payload[:machine_documentation_url]).to eq('https://particulier.api.gouv.fr/open-api.yml')
      expect(payload[:authorization_request_url]).to eq('https://datapass.api.gouv.fr/api-particulier')
    end

    it 'derives business and technical documentation urls from the api_particulier routes' do
      expect(payload[:business_documentation_url]).to eq('https://particulier.api.gouv.fr/catalogue/education_nationale/statut_eleve_scolarise')
      expect(payload[:technical_documentation_url]).to eq('https://particulier.api.gouv.fr/developpeurs/openapi#tag/Statut-eleve-scolarise/paths/~1v5~1men~1scolarites~1identite/get')
    end

    it 'joins the call_id array in the description' do
      expect(payload[:description]).to include("Modalité d'appel** : Identité pivot / FranceConnect.")
    end

    it 'builds tags from the base set and provider_uids only, since keywords is empty' do
      expect(payload[:tags]).to eq(%w[administration administration-et-legislation api-particulier education_nationale])
    end

    it 'uses a throttle period of 1 second worded as "seconde"' do
      expect(payload[:rate_limiting]).to eq('20 requêtes / seconde')
    end
  end

  context 'when the endpoint has no throttle entry' do
    let(:endpoint) do
      instance_double(
        APIEntreprise::Endpoint,
        uid: 'test/uid',
        api: 'api_entreprise',
        opening: 'protected',
        redoc_anchor: 'tag/Test/paths/~1v3~1test/get',
        title: 'Test',
        description: 'Description de test.',
        call_id: 'SIREN',
        provider_uids: ['insee'],
        keywords: ['test'],
        providers: [instance_double(APIEntreprise::Provider, name: 'INSEE')],
        throttle: nil
      )
    end

    it 'sets rate_limiting to an empty string when no throttle entry resolves' do
      expect(payload[:rate_limiting]).to eq('')
    end
  end

  context 'when the endpoint has no provider_uids' do
    subject(:payload) { described_class.new(endpoint).payload }

    let(:endpoint) do
      instance_double(
        APIEntreprise::Endpoint,
        uid: 'test/uid',
        api: 'api_entreprise',
        opening: 'protected',
        redoc_anchor: 'tag/Test/paths/~1v3~1test/get',
        title: 'Test',
        description: 'Description de test.',
        call_id: 'SIREN',
        provider_uids: nil,
        keywords: ['test'],
        throttle: nil
      )
    end

    it 'does not raise and omits the provider name from the title' do
      expect(endpoint).not_to receive(:providers)
      expect { payload }.not_to raise_error
      expect(payload[:title]).to eq('API Test -  | Bouquet API Entreprise')
    end

    it 'still includes the base tags' do
      expect(payload[:tags]).to eq(%w[administration administration-et-legislation api-entreprise test])
    end
  end

  describe 'API_CONFIG' do
    it 'uses api-particulier-scoped route helpers for API Particulier URLs' do
      particulier_config = described_class::API_CONFIG.fetch('api_particulier')

      expect(particulier_config[:business_documentation_url_helper]).to eq(:api_particulier_endpoint_url)
      expect(particulier_config[:technical_documentation_url_helper]).to eq(:api_particulier_developers_openapi_url)
      expect(particulier_config[:machine_documentation_url_helper]).to eq(:api_particulier_openapi_definition_url)
    end

    it 'uses api-entreprise-scoped route helpers for API Entreprise URLs' do
      entreprise_config = described_class::API_CONFIG.fetch('api_entreprise')

      expect(entreprise_config[:business_documentation_url_helper]).to eq(:endpoint_url)
      expect(entreprise_config[:technical_documentation_url_helper]).to eq(:developers_openapi_url)
      expect(entreprise_config[:machine_documentation_url_helper]).to eq(:openapi_without_deprecated_definition_url)
    end
  end

  describe '#creation_payload' do
    subject(:creation_payload) { described_class.new(endpoint).creation_payload }

    let(:endpoint) { APIEntreprise::Endpoint.find('dgfip/numero_tva') }
    let(:payload) { described_class.new(endpoint).payload }

    it 'adds the DINUM organization id on top of the regular payload' do
      expect(creation_payload).to eq(payload.merge(organization: '57fe2a35c751df21e179df72'))
    end
  end
end
