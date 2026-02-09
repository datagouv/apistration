RSpec.describe APIParticulier::PoleEmploi::Statut::V2, type: :serializer do
  subject(:serialized_resource) { described_class.new(bundled_data.data, { scope: current_user, scope_name: :current_user }).serializable_hash }

  let(:bundled_data) { FranceTravail::Statut::BuildResource.call(params: { identifiant: 'test' }, response:).bundled_data }
  let(:response) { OpenStruct.new(body:) }
  let(:body) { read_payload_file('france_travail/statut/valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with all france travail statut scopes' do
    let(:scopes) { %w[pole_emploi_identite pole_emploi_adresse pole_emploi_contact pole_emploi_inscription] }

    it 'has identite, adresse, contact, inscription items' do
      expect(subject).to have_key(:identifiant)
      expect(subject).to have_key(:civilite)
      expect(subject).to have_key(:nom)
      expect(subject).to have_key(:nomUsage)
      expect(subject).to have_key(:prenom)
      expect(subject).to have_key(:sexe)
      expect(subject).to have_key(:dateNaissance)

      expect(subject).to have_key(:codeCertificationCNAV)
      expect(subject).to have_key(:libelleCategorieInscription)
      expect(subject).to have_key(:dateInscription)
      expect(subject).to have_key(:dateCessationInscription)
      expect(subject).to have_key(:codeCategorieInscription)

      expect(subject).to have_key(:email)
      expect(subject).to have_key(:telephone)
      expect(subject).to have_key(:telephone2)

      expect(subject).to have_key(:adresse)
    end
  end

  context 'with partial france travail statut scopes' do
    context 'with pole_emploi_identite scope' do
      let(:scopes) { %w[pole_emploi_identite] }

      it 'has identite items' do
        expect(subject).to have_key(:identifiant)
        expect(subject).to have_key(:civilite)
        expect(subject).to have_key(:nom)
        expect(subject).to have_key(:nomUsage)
        expect(subject).to have_key(:prenom)
        expect(subject).to have_key(:sexe)
        expect(subject).to have_key(:dateNaissance)

        expect(subject).not_to have_key(:codeCertificationCNAV)
        expect(subject).not_to have_key(:libelleCategorieInscription)
        expect(subject).not_to have_key(:dateInscription)
        expect(subject).not_to have_key(:dateCessationInscription)
        expect(subject).not_to have_key(:codeCategorieInscription)

        expect(subject).not_to have_key(:email)
        expect(subject).not_to have_key(:telephone)
        expect(subject).not_to have_key(:telephone2)

        expect(subject).not_to have_key(:adresse)
      end
    end

    context 'with pole_emploi_inscription scope' do
      let(:scopes) { %w[pole_emploi_inscription] }

      it 'has inscription items' do
        expect(subject).not_to have_key(:identifiant)
        expect(subject).not_to have_key(:civilite)
        expect(subject).not_to have_key(:nom)
        expect(subject).not_to have_key(:nomUsage)
        expect(subject).not_to have_key(:prenom)
        expect(subject).not_to have_key(:sexe)
        expect(subject).not_to have_key(:dateNaissance)

        expect(subject).to have_key(:codeCertificationCNAV)
        expect(subject).to have_key(:libelleCategorieInscription)
        expect(subject).to have_key(:dateInscription)
        expect(subject).to have_key(:dateCessationInscription)
        expect(subject).to have_key(:codeCategorieInscription)

        expect(subject).not_to have_key(:email)
        expect(subject).not_to have_key(:telephone)
        expect(subject).not_to have_key(:telephone2)

        expect(subject).not_to have_key(:adresse)
      end
    end

    context 'with pole_emploi_contact scope' do
      let(:scopes) { %w[pole_emploi_contact] }

      it 'has contact items' do
        expect(subject).not_to have_key(:identifiant)
        expect(subject).not_to have_key(:civilite)
        expect(subject).not_to have_key(:nom)
        expect(subject).not_to have_key(:nomUsage)
        expect(subject).not_to have_key(:prenom)
        expect(subject).not_to have_key(:sexe)
        expect(subject).not_to have_key(:dateNaissance)

        expect(subject).not_to have_key(:codeCertificationCNAV)
        expect(subject).not_to have_key(:libelleCategorieInscription)
        expect(subject).not_to have_key(:dateInscription)
        expect(subject).not_to have_key(:dateCessationInscription)
        expect(subject).not_to have_key(:codeCategorieInscription)

        expect(subject).to have_key(:email)
        expect(subject).to have_key(:telephone)
        expect(subject).to have_key(:telephone2)

        expect(subject).not_to have_key(:adresse)
      end
    end

    context 'with pole_emploi_adresse scope' do
      let(:scopes) { %w[pole_emploi_adresse] }

      it 'has adresse items' do
        expect(subject).not_to have_key(:identifiant)
        expect(subject).not_to have_key(:civilite)
        expect(subject).not_to have_key(:nom)
        expect(subject).not_to have_key(:nomUsage)
        expect(subject).not_to have_key(:prenom)
        expect(subject).not_to have_key(:sexe)
        expect(subject).not_to have_key(:dateNaissance)

        expect(subject).not_to have_key(:codeCertificationCNAV)
        expect(subject).not_to have_key(:libelleCategorieInscription)
        expect(subject).not_to have_key(:dateInscription)
        expect(subject).not_to have_key(:dateCessationInscription)
        expect(subject).not_to have_key(:codeCategorieInscription)

        expect(subject).not_to have_key(:email)
        expect(subject).not_to have_key(:telephone)
        expect(subject).not_to have_key(:telephone2)

        expect(subject).to have_key(:adresse)

        expect(subject[:adresse]).to have_key(:INSEECommune)
        expect(subject[:adresse]).to have_key(:codePostal)
        expect(subject[:adresse]).to have_key(:ligneComplementAdresse)
        expect(subject[:adresse]).to have_key(:ligneComplementDestinataire)
        expect(subject[:adresse]).to have_key(:ligneComplementDistribution)
        expect(subject[:adresse]).to have_key(:ligneNom)
        expect(subject[:adresse]).to have_key(:ligneVoie)
        expect(subject[:adresse]).to have_key(:localite)
      end
    end
  end
end
