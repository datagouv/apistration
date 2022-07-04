RSpec.describe SIADE::V2::Drivers::Associations, type: :provider_driver do
  let(:invalid_xml_siret)                  { '00000000000000' }
  let(:siret_association_utilite_publique) { '77571979202585' }

  context 'Invalid Xml response' do
    subject { described_class.new({ association_id: invalid_siret }).perform_request }

    let(:url) { "https://siva.jeunesse-sports.gouv.fr/cxf/api/structure/#{invalid_xml_siret}" }

    before do
      stub_request(:get, url).to_return(status: 200, body: '{invalid xml}')
      subject.titre # try to load data from XML to generate an error
    end

    its(:http_code) { is_expected.to eq(502) }
    its(:titre)     { is_expected.to eq(SIADE::V2::Drivers::GenericDriver.new.send(:placeholder)) } # never sent because it's a code 500 error
    its(:errors)    { is_expected.to have_error('Echec lors du parcours du fichier XML rna association.') }
  end # end invalid xml

  context 'asso with 0 documents', vcr: { cassette_name: 'mi/associations/documents/without_document' } do
    subject { described_class.new(association_id: rna_id_without_documents).perform_request }

    its(:nombre_documents) { is_expected.to eq(0) }
    its(:documents) { is_expected.to eq [] }
  end

  context '[siret_association_utilite_publique] Rna et Sirene', vcr: { cassette_name: 'mi/associations/documents/with_documents' } do
    # Test speed up by a x10 factor
    subject { @association_utilite_publique }

    before do
      remember_through_each_test_of_current_scope('association_utilite_publique') do
        described_class.new({ association_id: siret_association_utilite_publique }).perform_request
      end
    end

    its(:siren)                       { is_expected.to eq(siret_association_utilite_publique.first(9)) }
    its(:siret)                       { is_expected.to eq(siret_association_utilite_publique) }
    its(:http_code)                   { is_expected.to eq(200) }
    its(:id)                          { is_expected.to eq('W751107336') }
    its(:titre)                       { is_expected.to eq('LA PREVENTION ROUTIERE') }
    its(:objet)                       { is_expected.to eq('Accroitre la sécurité des usagers en encourageant toutes mesures ou initiatives propres à réduire les accidents') }
    its(:siret_siege_social)          { is_expected.to eq('77571979202650') }
    its(:date_creation)               { is_expected.to eq('1955-01-01') }
    its(:date_declaration)            { is_expected.to eq('2022-04-26') }
    its(:date_publication)            { is_expected.to eq('0001-01-01') }
    its(:date_dissolution)            { is_expected.to eq('0001-01-01') }
    its(:adresse_siege_complement_1)  { is_expected.to eq(nil) }
    its(:adresse_siege_complement_2)  { is_expected.to eq(nil) }
    its(:adresse_siege_complement_3)  { is_expected.to eq('_') }
    its(:adresse_siege_numero_voie)   { is_expected.to eq('33') }
    its(:adresse_siege_type_voie)     { is_expected.to eq('RUE') }
    its(:adresse_siege_libelle_voie)  { is_expected.to eq('de Mogador') }
    its(:adresse_siege_distribution)  { is_expected.to eq(nil) }
    its(:adresse_siege_code_insee)    { is_expected.to eq('75109') }
    its(:adresse_siege_code_postal)   { is_expected.to eq('75009') }
    its(:adresse_siege_commune)       { is_expected.to eq('Paris 9ème') }
    its(:code_civilite_dirigeant)     { is_expected.to eq(nil) }
    its(:civilite_dirigeant)          { is_expected.to eq(nil) }
    its(:code_etat)                   { is_expected.to eq(nil) }
    its(:etat)                        { is_expected.to eq('true') }
    its(:code_groupement)             { is_expected.to eq(nil) }
    its(:groupement)                  { is_expected.to eq('Simple') }
    its(:mise_a_jour)                 { is_expected.to eq('2022-04-26') }

    describe 'documents' do
      its(:nombre_documents)          { is_expected.to eq(12) }
      its(:documents)                 { is_expected.to be_a_kind_of(Array) }
      its('documents.size')           { is_expected.to eq(12) }

      describe 'document_structure' do
        subject { @association_utilite_publique_first_document }

        before do
          remember_through_each_test_of_current_scope('association_utilite_publique_first_document') do
            described_class.new({ association_id: siret_association_utilite_publique }).perform_request.documents[0]
          end
        end

        its(['timestamp']) { is_expected.to eq('1411134260') }
        its(['type'])      { is_expected.to eq('Statuts') }
        its(['url'])       { is_expected.to match(%r{/api-asso/api/documents/PJ}) }
      end
    end
  end
end
