RSpec.describe CNAV::ParticipationFamilialeEAJE::BuildAttestationProof do
  subject(:proof) { described_class.call(**context_args) }

  let(:context_args) do
    {
      generate_proof_mode:,
      scopes:,
      recipient: '13002526500013',
      habilitation: 'a11b0000-0000-0000-0000-000000000042',
      bundled_data: BundledData.new(data: Resource.new(data))
    }
  end

  let(:generate_proof_mode) { 'proof-only' }

  let(:scopes) do
    %w[
      cnav_participation_familiale_eaje_allocataires
      cnav_participation_familiale_eaje_enfants
      cnav_participation_familiale_eaje_adresse
      cnav_participation_familiale_eaje_parametres_calcul
    ]
  end

  let(:data) do
    {
      'allocataires' => [
        { 'nom_naissance' => 'DUPOND', 'prenoms' => 'JEAN-MICHEL', 'date_naissance' => '1981-06-30', 'sexe' => 'M' }
      ],
      'enfants' => [
        { 'nom_naissance' => 'DUPOND', 'prenoms' => 'MARIE', 'date_naissance' => '2020-03-15', 'sexe' => 'F' },
        { 'nom_naissance' => 'DUPOND', 'prenoms' => 'PAUL', 'date_naissance' => '2022-11-02', 'sexe' => 'M' }
      ],
      'adresse' => { 'numero_libelle_voie' => '32 ter rue du Pont du Roy' },
      'parametres_calcul_participation_familiale' => {
        'nombre_enfants_a_charge' => 2,
        'base_ressources_annuelles' => { 'valeur' => 40_923, 'annee_calcul' => 2023 }
      }
    }
  end

  let(:verification_payload) do
    AttestationToken.read(proof.verification_token, purpose: AttestationToken::VERIFICATION_PURPOSE)
  end

  it 'is a no-op unless a proof mode was asked for' do
    result = described_class.call(**context_args, generate_proof_mode: nil)

    expect(result).to be_a_success
    expect(result.verification_token).to be_nil
  end

  describe 'the verification token' do
    it 'is self-contained — labels, titles and formatted values are resolved at issuance' do
      expect(verification_payload).to eq(
        'siret' => '13002526500013',
        'emise_le' => Time.zone.today.iso8601,
        'valable_jusqu_au' => (Time.zone.today + 5.years).iso8601,
        'sections' => [
          { 'titre' => 'Allocataires',
            'entrees' => [[['Nom de naissance', 'DUP•••'], ['Date de naissance', '06/1981']]] },
          { 'titre' => 'Enfants',
            'entrees' => [[["Nombre d'enfants", '2']]] },
          { 'titre' => 'Paramètres de calcul de la participation familiale',
            'entrees' => [[["Nombre d'enfants à charge", '2'],
                           ['Base de ressources annuelles', { 'highlight' => '40 923' }],
                           ['Année de calcul', '2023']]] }
        ]
      )
    end

    it 'minimises identities — RSSI §4.4 keeps what a concordance check needs, no more' do
      expect(verification_payload.to_json).not_to include('JEAN-MICHEL')
    end

    it 'grows by a digit, not by a child — the family is a count, not a list' do
      large = data.merge('enfants' => Array.new(15) { data['enfants'].first })

      growth = described_class.call(**args_for(large)).verification_token.size -
               described_class.call(**args_for(data)).verification_token.size

      expect(growth).to be <= 8
    end

    context 'when a scope is missing' do
      let(:scopes) { super() - %w[cnav_participation_familiale_eaje_enfants] }

      it 'drops the section instead of exposing data the caller is not entitled to' do
        titles = verification_payload['sections'].pluck('titre')

        expect(titles).to eq(['Allocataires', 'Paramètres de calcul de la participation familiale'])
      end
    end

    context 'when the provider left a hole in the data' do
      let(:data) { super().except('enfants') }

      it 'drops the section instead of rendering an empty one' do
        titles = verification_payload['sections'].pluck('titre')

        expect(titles).to eq(['Allocataires', 'Paramètres de calcul de la participation familiale'])
      end
    end

    context 'when the provider returned an empty list of children' do
      let(:data) { super().merge('enfants' => []) }

      it 'drops the section on both documents — the concordance check must compare identical shapes' do
        expect(verification_payload['sections'].pluck('titre')).not_to include('Enfants')
      end
    end

    context 'when the provider returned a malformed date' do
      let(:generate_proof_mode) { 'pdf' }
      let(:data) do
        super().merge('allocataires' => [{ 'nom_naissance' => 'DUPOND', 'date_naissance' => '2020-99-99' }])
      end

      it 'keeps the raw value instead of failing the whole call' do
        pdf_payload = AttestationToken.read(proof.pdf_token, purpose: AttestationToken::PDF_PURPOSE)

        expect(pdf_payload['sections'].first['entrees'].first).to include(['Date de naissance', '2020-99-99'])
      end
    end
  end

  describe 'the verification link' do
    it { expect(proof.verification_url).to eq("https://test.particulier.api.gouv.fr/attestations/verification/#{proof.verification_token}") }
    it { expect(proof.visual_code).to match(/\A[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{2}\z/) }
  end

  describe 'the pdf token' do
    it 'is not minted unless it was asked for' do
      expect(proof.pdf_token).to be_nil
      expect(proof.pdf_link_expires_at).to be_nil
    end

    context 'when requested' do
      subject(:pdf_payload) { AttestationToken.read(proof.pdf_token, purpose: AttestationToken::PDF_PURPOSE) }

      let(:generate_proof_mode) { 'pdf' }

      it 'carries the full attestation, its identity, its habilitation and the verification token' do
        expect(pdf_payload['document']).to eq('participation_familiale_eaje')
        expect(pdf_payload['titre']).to eq('ATTESTATION DE PARTICIPATION FAMILIALE (EAJE)')
        expect(pdf_payload['source']).to eq('CNAF')
        expect(pdf_payload['sections'].pluck('titre'))
          .to eq(['Allocataires', 'Enfants', 'Adresse', 'Paramètres de calcul de la participation familiale'])
        expect(pdf_payload['habilitation']).to eq('a11b0000-0000-0000-0000-000000000042')
        expect(pdf_payload['verification_token']).to eq(proof.verification_token)
      end

      it 'resolves identities, values and formats at issuance' do
        allocataire = pdf_payload['sections'].first['entrees'].first

        expect(allocataire).to include(%w[Prénoms JEAN-MICHEL])
        expect(allocataire).to include(%w[Sexe Masculin])
        expect(allocataire).to include(['Date de naissance', '30/06/1981'])
      end

      it 'expires long before the verification link does' do
        expect(proof.pdf_link_expires_at).to be_within(5).of(5.minutes.from_now.to_i)
      end
    end
  end

  def args_for(data)
    context_args.merge(bundled_data: BundledData.new(data: Resource.new(data)))
  end
end
