RSpec.describe APIParticulier::NoResultAttestationProofBuilder do
  subject(:pdf_payload) { AttestationToken.read(proof.pdf_token, purpose: AttestationToken::PDF_PURPOSE) }

  let(:proof) do
    described_class.new(
      { 'errors' => [error] },
      attestation:,
      request_params:,
      recipient: '13002526500013',
      habilitation: 'a11b0000-0000-0000-0000-000000000042'
    )
  end

  let(:attestation) { :no_result }

  let(:error) do
    {
      'code' => '23003',
      'title' => 'Dossier allocataire absent CNAF',
      'detail' => "Le dossier allocataire n'a pas été trouvé auprès de la CNAF.",
      'meta' => { 'provider' => 'CNAF', 'origine' => 'CNAF' }
    }
  end

  let(:request_params) do
    {
      nom_naissance: 'CHAMPION',
      nom_usage: nil,
      prenoms: %w[JEAN PASCAL],
      annee_date_naissance: '1980',
      mois_date_naissance: '6',
      jour_date_naissance: '12',
      sexe_etat_civil: 'M',
      code_cog_insee_pays_naissance: '99100',
      code_cog_insee_commune_naissance: '17300',
      nom_commune_naissance: nil,
      code_cog_insee_departement_naissance: nil
    }
  end

  let(:verification_payload) do
    AttestationToken.read(proof.verification_token, purpose: AttestationToken::VERIFICATION_PURPOSE)
  end

  around { |example| Timecop.freeze(Time.zone.local(2026, 10, 13, 14, 32, 5)) { example.run } }

  context 'when the consultation found no file' do
    it 'is titled as a consultation without result' do
      expect(pdf_payload['titre']).to eq('ATTESTATION DE CONSULTATION SANS RÉSULTAT')
    end

    it 'states the result of the consultation, where it comes from and when the call was made' do
      expect(pdf_payload['sections'].first).to eq(
        'titre' => 'Résultat de la consultation',
        'entrees' => [[
          ['Erreur', 'Dossier allocataire absent CNAF'],
          ['Détail', "Le dossier allocataire n'a pas été trouvé auprès de la CNAF."],
          ['Origine', 'CNAF'],
          ["Date et heure de l'appel", '13/10/2026 à 14:32:05']
        ]]
      )
    end

    it 'states the identity exactly as the caller sent it' do
      expect(pdf_payload['sections'].second).to eq(
        'titre' => "Identité de l'usager transmise lors de l'appel",
        'entrees' => [[
          ['Nom de naissance', 'CHAMPION'],
          ['Prénoms', 'JEAN PASCAL'],
          ['Date de naissance', '12/06/1980'],
          ['Sexe', 'Masculin'],
          ['Code INSEE du pays de naissance', '99100'],
          ['Code INSEE de la commune de naissance', '17300']
        ]]
      )
    end

    it 'names the register that answered as the source' do
      expect(pdf_payload['source']).to eq('CNAF')
    end

    it 'carries the document, the habilitation and the verification token' do
      expect(pdf_payload['document']).to eq('consultation')
      expect(pdf_payload['habilitation']).to eq('a11b0000-0000-0000-0000-000000000042')
      expect(pdf_payload['verification_token']).to eq(proof.verification_token)
    end

    it 'keeps the same result and a minimised identity in the verification token' do
      expect(verification_payload['sections']).to eq(
        [
          pdf_payload['sections'].first,
          { 'titre' => "Identité de l'usager transmise lors de l'appel",
            'entrees' => [[['Nom de naissance', 'CHA•••'], ['Date de naissance', '06/1980']]] }
        ]
      )
    end
  end

  context 'when the file was found but is not eligible' do
    let(:attestation) { :not_eligible }

    it 'is titled as a file found but not eligible' do
      expect(pdf_payload['titre']).to eq('ATTESTATION DE CONSULTATION : DOSSIER NON ÉLIGIBLE')
    end
  end

  context 'when the MSA answered' do
    let(:error) { super().merge('meta' => { 'provider' => 'MSA', 'origine' => 'MSA' }) }

    it 'names the MSA as the source' do
      expect(pdf_payload['source']).to eq('MSA')
    end
  end

  context 'when the error does not name its origin' do
    let(:error) { super().merge('meta' => { 'provider' => 'CNAV' }) }

    it 'says so as the source instead of naming a register' do
      expect(pdf_payload['source']).to eq('origine non communiquée')
    end

    it 'says so in the result of the consultation' do
      expect(pdf_payload['sections'].first['entrees'].first).to include(['Origine', 'origine non communiquée'])
    end
  end

  context 'when the caller sent the birthplace by name instead of its COG code' do
    let(:request_params) do
      super().merge(code_cog_insee_commune_naissance: nil, nom_commune_naissance: 'La Rochelle', code_cog_insee_departement_naissance: '17')
    end

    it 'states the commune and the département as sent' do
      expect(pdf_payload['sections'].second['entrees'].first).to include(
        ['Commune de naissance', 'La Rochelle'],
        ['Code INSEE du département de naissance', '17']
      )
    end
  end
end
