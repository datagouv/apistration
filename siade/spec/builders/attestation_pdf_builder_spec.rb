RSpec.describe AttestationPDFBuilder do
  subject(:text) { reader.pages.map(&:text).join(' ').squish }

  let(:reader) { PDF::Reader.new(StringIO.new(pdf)) }

  let(:pdf) do
    described_class.new(
      payload:,
      visual_code: 'ABCDE-12345',
      verification_url: 'https://particulier.api.gouv.fr/attestations/verification?token=abc',
      test: false
    ).render
  end

  let(:payload) do
    {
      'document' => 'participation_familiale_eaje',
      'titre' => 'ATTESTATION DE PARTICIPATION FAMILIALE (EAJE)',
      'source' => 'CNAF',
      'siret' => '13002526500013',
      'emise_le' => '2026-07-23',
      'sections' => sections
    }
  end

  let(:sections) do
    [
      { 'titre' => 'Allocataires',
        'entrees' => [[
          ['Nom de naissance', 'LEFEBVRE'],
          ['Prénoms', 'JEAN-PIERRE THOMAS'],
          ['Date de naissance', '20/01/2000'],
          ['Sexe', 'Masculin'],
          ['Code INSEE de la commune de naissance', '08480']
        ]] },
      { 'titre' => 'Enfants',
        'entrees' => [[
          ['Nom de naissance', 'LEFEBVRE'],
          ['Prénoms', 'JEAN-PIERRE THOMAS JUNIOR'],
          ['Date de naissance', '20/01/2020'],
          ['Sexe', 'Masculin']
        ]] },
      { 'titre' => 'Adresse',
        'entrees' => [[
          ['Destinataire', 'M LEFEBVRE JEAN-PIERRE'],
          ['Numéro et libellé de voie', '1 RUE DE LA GARE'],
          ['Code postal / Ville', '75002 PARIS'],
          ['Pays', 'FRANCE']
        ]] },
      { 'titre' => 'Paramètres de calcul de la participation familiale',
        'entrees' => [[
          ["Nombre d'enfants à charge", '1'],
          ["Nombre d'enfants bénéficiaires de l'AEEH", '1'],
          ['Base de ressources annuelles', { 'highlight' => '40 923' }],
          ['Année de calcul', '2023']
        ]] }
    ]
  end

  it { is_expected.to include('ABCDE-12345') }
  it { is_expected.to include('13002526500013') }
  it { is_expected.to include('LEFEBVRE') }
  it { is_expected.to include('40 923') }
  it { is_expected.to include('23/07/2026') }
  it { is_expected.not_to include('donnees de test') }

  describe 'header' do
    it { is_expected.to include('RÉPUBLIQUE FRANÇAISE') }
    it { is_expected.to include('Source : CNAF') }
    it { is_expected.to include('ATTESTATION DE PARTICIPATION FAMILIALE (EAJE)') }
    it { is_expected.to include('Document délivré le 23/07/2026 — à valeur justificative') }
  end

  describe 'footer' do
    it { is_expected.to include("Vérifier l'authenticité de ce document") }
    it { is_expected.to include('Émis pour le compte du SIRET 13002526500013, le 23/07/2026') }

    it 'repeats the visual code next to the QR code' do
      expect(text.scan('ABCDE-12345').count).to eq(2)
    end

    it 'offers the click alternative with the target domain spelled out' do
      expect(text).to include('ou cliquez ici')
      expect(text).to include('sur particulier.api.gouv.fr')
    end

    it 'links the footer to the verification page for digital readers' do
      doc = HexaPDF::Document.new(io: StringIO.new(pdf))
      links = doc.pages.first[:Annots].to_a.select { |annotation| annotation[:Subtype] == :Link }

      expect(links.map { |annotation| annotation[:A][:URI] })
        .to eq(['https://particulier.api.gouv.fr/attestations/verification?token=abc'])
    end
  end

  describe 'field grid — the payload is rendered verbatim, the builder resolves nothing' do
    it { is_expected.to include('Nom de naissance LEFEBVRE') }
    it { is_expected.to include('Prénoms JEAN-PIERRE THOMAS') }
    it { is_expected.to include('Date de naissance 20/01/2000') }
    it { is_expected.to include('Sexe Masculin') }
    it { is_expected.to include('Numéro et libellé de voie 1 RUE DE LA GARE') }
    it { is_expected.to include('Code postal / Ville 75002 PARIS') }
    it { is_expected.to include('Base de ressources annuelles 40 923') }
    it { is_expected.to include('Année de calcul 2023') }
    it { is_expected.to include('ALLOCATAIRES') }
    it { is_expected.to include('PARAMÈTRES DE CALCUL DE LA PARTICIPATION FAMILIALE') }
  end

  it 'draws the QR code as vector rectangles' do
    expect(reader.page(1).raw_content.scan(/\bre\b/).count).to be > 100
  end

  context 'with test data' do
    let(:pdf) do
      described_class.new(
        payload:,
        visual_code: 'ABCDE-12345',
        verification_url: 'https://staging.particulier.api.gouv.fr/attestations/verification?token=abc',
        test: true
      ).render
    end

    it { is_expected.to include('DONNÉES DE TEST') }
  end

  context 'with a large family behind the QR code (capacity regression)' do
    let(:pdf) do
      verification_payload = payload.merge('sections' => [
        { 'titre' => 'Allocataires',
          'entrees' => Array.new(2) { [['Nom de naissance', 'LEF•••'], ['Date de naissance', '12/1982']] } },
        { 'titre' => 'Enfants', 'entrees' => [[["Nombre d'enfants", '9']]] },
        sections.last
      ])
      token = AttestationToken.generate(verification_payload, purpose: AttestationToken::VERIFICATION_PURPOSE, expires_in: 5.years)

      described_class.new(
        payload:,
        visual_code: AttestationToken.visual_code(token),
        verification_url: "https://particulier.api.gouv.fr/attestations/verification/#{token}",
        test: false
      ).render
    end

    it { is_expected.to include('ENFANTS') }
  end

  context 'when a section does not fit in the space left on the page' do
    let(:sections) do
      person = [
        ['Nom de naissance', 'LEFEBVRE'],
        ["Nom d'usage", 'LEFEBVRE'],
        ['Prénoms', 'CAPUCINE ANAELLE'],
        ['Date de naissance', '09/03/1987'],
        ['Sexe', 'Féminin']
      ]

      [
        { 'titre' => 'Allocataires', 'entrees' => Array.new(2) { person } },
        { 'titre' => 'Enfants', 'entrees' => [person] },
        { 'titre' => 'Adresse',
          'entrees' => [[
            ['Destinataire', 'MME LEFEBVRE CAPUCINE'],
            ['Numéro et libellé de voie', '31 AVENUE DES TROIS FONTAINES'],
            ['Code postal / Ville', '05380 CHATEAUROUX LES ALPES'],
            ['Pays', 'FRANCE']
          ]] },
        { 'titre' => 'Paramètres de calcul de la participation familiale',
          'entrees' => [[
            ["Nombre d'enfants bénéficiaires de l'AEEH", '0'],
            ["Nombre d'enfants à charge", '1'],
            ['Base de ressources annuelles', { 'highlight' => '61 754' }],
            ['Année de calcul', '2024']
          ]] }
      ]
    end

    it 'moves the whole section to the next page instead of splitting it' do
      reader.pages.each do |page|
        page_text = page.text.squish

        expect(page_text).to include('Année de calcul') if page_text.include?('PARAMÈTRES DE CALCUL')
      end
    end
  end

  context 'with partial data (scopes limited the sections at issuance)' do
    let(:sections) do
      [{ 'titre' => 'Allocataires', 'entrees' => [[['Nom de naissance', 'LEF…'], ['Prénoms', 'J. T.']]] }]
    end

    it { is_expected.to include('LEF…') }
    it { is_expected.not_to include('ENFANTS') }
  end
end
