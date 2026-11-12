RSpec.describe APIParticulier::MESRI::StatutEtudiantSerializer::AttestationProofBuilder do
  subject(:proof) { proof_for(data) }

  let(:data) do
    {
      'identite' => { 'nom_naissance' => 'CALIDONE', 'prenom' => 'Lola', 'date_naissance' => '2005-01-01' },
      'admissions' => [
        {
          'date_debut' => '2024-09-01',
          'date_fin' => '2025-07-31',
          'est_inscrit' => true,
          'regime_formation' => { 'libelle' => 'formation initiale', 'code' => 'RF1' },
          'code_cog_insee_commune' => '92000',
          'etablissement_etudes' => { 'uai' => '0334523W', 'nom' => 'Université Paris Nanterre' }
        },
        {
          'date_debut' => '2025-09-01',
          'date_fin' => '2026-07-31',
          'est_inscrit' => false,
          'regime_formation' => { 'libelle' => "contrat d'apprentissage", 'code' => 'RF4' },
          'code_cog_insee_commune' => '75113',
          'etablissement_etudes' => { 'uai' => '0751967F', 'nom' => 'UFR ECONOMIE UNIVERSITE PARIS 1' }
        }
      ]
    }
  end

  let(:verification_payload) do
    AttestationToken.read(proof.verification_token, purpose: AttestationToken::VERIFICATION_PURPOSE)
  end

  describe 'the verification token' do
    it 'is self-contained — labels, titles and formatted values are resolved at issuance' do
      expect(verification_payload).to eq(
        'siret' => '13002526500013',
        'emise_le' => Time.zone.today.iso8601,
        'valable_jusqu_au' => (Time.zone.today + 5.years).iso8601,
        'sections' => [
          { 'titre' => 'Étudiant',
            'entrees' => [[['Nom de naissance', 'CAL•••'], ['Date de naissance', '01/2005']]] },
          { 'titre' => 'Admissions',
            'entrees' => [[["Nombre d'admissions", '2'],
                           ['Dont inscriptions', '1'],
                           ["Période d'études couverte", '01/09/2024 – 31/07/2026'],
                           ["Dernier établissement d'études", 'UFR ECONOMIE UNIVERSITE PARIS 1']]] }
        ]
      )
    end

    it 'minimises the identity — RSSI §4.4 keeps what a concordance check needs, no more' do
      expect(verification_payload.to_json).not_to include('CALIDONE', 'Lola')
    end

    it 'grows by a digit, not by an admission — the curriculum is a résumé, not a list' do
      growth = proof_for(curriculum(60)).verification_url.size - proof_for(curriculum(1)).verification_url.size

      expect(growth).to be <= 64
    end

    it 'stays scannable — a whole curriculum keeps the QR code of the link at a usable density' do
      modules = RQRCodeCore::QRCode.new(proof_for(curriculum(60)).verification_url, level: :m).modules.size

      expect(modules).to be <= 117
    end

    context 'when the provider left a hole in the data' do
      let(:data) { super().except('admissions') }

      it 'drops the section instead of rendering an empty one' do
        expect(verification_payload['sections'].pluck('titre')).to eq(['Étudiant'])
      end
    end

    context 'when the token grants neither the dates nor the establishment' do
      let(:data) { super().merge('admissions' => [{ 'est_inscrit' => true }]) }

      it 'counts the admissions instead of rendering empty rows' do
        expect(verification_payload['sections'].second['entrees'].first)
          .to eq([["Nombre d'admissions", '1'], ['Dont inscriptions', '1']])
      end
    end

    context 'when the token does not grant the enrolment state' do
      let(:data) do
        super().merge('admissions' => super()['admissions'].map { |admission| admission.except('est_inscrit') })
      end

      it 'drops the count instead of attesting none for five years' do
        expect(verification_payload['sections'].second['entrees'].first.map(&:first))
          .not_to include('Dont inscriptions')
      end

      it 'keeps what the provider did say' do
        expect(verification_payload['sections'].second['entrees'].first)
          .to include(["Nombre d'admissions", '2'], ["Période d'études couverte", '01/09/2024 – 31/07/2026'])
      end
    end

    context 'when one admission comes without its dates' do
      let(:data) do
        super().merge('admissions' => [super()['admissions'].first,
                                       super()['admissions'].second.except('date_debut', 'date_fin')])
      end

      it 'drops the period rather than attesting a shorter one than the truth' do
        expect(verification_payload['sections'].second['entrees'].first.map(&:first))
          .not_to include("Période d'études couverte")
      end

      it 'drops the last establishment, which the list order alone would decide' do
        expect(verification_payload['sections'].second['entrees'].first.map(&:first))
          .not_to include("Dernier établissement d'études")
      end
    end

    context 'when no admission has been turned into an enrolment' do
      let(:data) { super().merge('admissions' => [super()['admissions'].second]) }

      it 'says none instead of dropping the row — zero is an answer, not a hole' do
        expect(verification_payload['sections'].second['entrees'].first)
          .to include(['Dont inscriptions', '0'])
      end
    end
  end

  describe 'the verification link' do
    it { expect(proof.verification_url).to eq("https://test.particulier.api.gouv.fr/attestations/verification/#{proof.verification_token}") }
    it { expect(proof.visual_code).to match(/\A[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{2}\z/) }
  end

  describe 'the pdf token' do
    subject(:pdf_payload) { AttestationToken.read(proof.pdf_token, purpose: AttestationToken::PDF_PURPOSE) }

    it 'carries the full attestation, its identity, its habilitation and the verification token' do
      expect(pdf_payload['document']).to eq('statut_etudiant')
      expect(pdf_payload['titre']).to eq('ATTESTATION DE STATUT ÉTUDIANT')
      expect(pdf_payload['source']).to eq('MESRI')
      expect(pdf_payload['sections'].pluck('titre')).to eq(%w[Étudiant Admissions])
      expect(pdf_payload['habilitation']).to eq('a11b0000-0000-0000-0000-000000000042')
      expect(pdf_payload['verification_token']).to eq(proof.verification_token)
    end

    it 'resolves the identity and the dates at issuance' do
      expect(pdf_payload['sections'].first['entrees'].first).to eq(
        [['Nom de naissance', 'CALIDONE'], %w[Prénom Lola], ['Date de naissance', '01/01/2005']]
      )
    end

    it 'spells out every admission — the attestation is the document, the public page only its résumé' do
      expect(pdf_payload['sections'].second['entrees'].map(&:first)).to eq(
        [["Début de la période d'études", '01/09/2024'],
         ["Début de la période d'études", '01/09/2025']]
      )
      expect(pdf_payload['sections'].second['entrees'].map { |entry| entry.to_h["État de l'inscription"] })
        .to eq(['Inscrit', 'Admis, non inscrit'])
    end

    it 'keeps a whole curriculum, however long' do
      payload = AttestationToken.read(proof_for(curriculum(60)).pdf_token, purpose: AttestationToken::PDF_PURPOSE)

      expect(payload['sections'].second['entrees'].size).to eq(60)
    end

    context 'when the token does not grant the admission details' do
      let(:data) do
        super().merge('admissions' => [super()['admissions'].first.slice('date_debut', 'date_fin')])
      end

      it 'keeps the dates alone instead of rendering empty rows' do
        expect(pdf_payload['sections'].second['entrees'].first.map(&:first))
          .to eq(["Début de la période d'études", "Fin de la période d'études"])
      end
    end

    context 'when the provider returned a malformed date' do
      let(:data) do
        super().merge('admissions' => [super()['admissions'].first.merge('date_fin' => '2025-99-99')])
      end

      it 'keeps the raw value instead of failing the whole call' do
        expect(pdf_payload['sections'].second['entrees'].first)
          .to include(["Fin de la période d'études", '2025-99-99'])
      end
    end

    it 'expires long before the verification link does' do
      expect(proof.pdf_link_expires_at).to be_within(5).of(5.minutes.from_now.to_i)
    end
  end

  def proof_for(data, source: 'MESRI')
    described_class.new(
      { 'data' => data, 'links' => {}, 'meta' => {} },
      source:,
      recipient: '13002526500013',
      habilitation: 'a11b0000-0000-0000-0000-000000000042'
    )
  end

  # Each admission differs from the others — identical ones would be squeezed
  # out by the deflate of AttestationToken and measure nothing.
  def curriculum(size)
    data.merge('admissions' => Array.new(size) { |index| distinct_admission(index) })
  end

  def distinct_admission(index)
    data['admissions'].first.merge(
      'date_debut' => "#{1996 + index}-09-01",
      'date_fin' => "#{1997 + index}-07-31",
      'est_inscrit' => index.even?,
      'code_cog_insee_commune' => format('%<code>05d', code: 13_000 + (index * 37)),
      'etablissement_etudes' => distinct_etablissement(index)
    )
  end

  def distinct_etablissement(index)
    { 'uai' => format('%<uai>07dX', uai: index * 4253),
      'nom' => "UNIVERSITE DE #{'MONTPELLIER'.chars.rotate(index).join} #{index}" }
  end
end
