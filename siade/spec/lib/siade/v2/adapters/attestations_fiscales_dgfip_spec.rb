RSpec.describe SIADE::V2::Adapters::AttestationsFiscalesDGFIP do
  let(:user_id)           { valid_dgfip_user_id }
  let(:siren)             { valid_siren(:dgfip) }
  let(:siren_is)          { danone_siren }
  let(:siren_tva)         { danone_siren }
  let(:entreprise_is)     { SIADE::V3::Drivers::INSEE::Entreprise.new(siren: siren_is) }
  let(:etablissement_is)  { SIADE::V3::Drivers::INSEE::Etablissement.new(siret: entreprise_is.siret_siege_social) }
  let(:entreprise_tva)    { entreprise_is }
  let(:etablissement_tva) { etablissement_is }

  before do
    entreprise_is.perform_request
    etablissement_is.perform_request
  end

  describe 'is not valid' do
    describe 'when siren IS is provided', vcr: { cassette_name: 'attestations_fiscales_dgfip_adapter' } do
      subject do
        described_class.new(
          {
            siren: siren,
            entreprise_is: entreprise_is,
            etablissement_is: etablissement_is,
            user_id: user_id
          }
        )
      end

      it 'is not valid' do
        subject.groupe_is = 'NOPE'
        expect(subject).not_to be_valid
        expect(subject.errors).not_to be_empty
      end
    end
  end

  describe 'happy path' do
    describe 'when siren IS or TVA is provided', vcr: { cassette_name: 'attestations_fiscales_dgfip_adapter' } do
      context 'when IS is provided' do
        subject do
          described_class.new(
            {
              siren: siren,
              entreprise_is: entreprise_is,
              etablissement_is: etablissement_is,
              user_id: user_id
            }
          )
        end

        it { is_expected.to be_valid }

        it 'has all the keys' do
          hash = subject.to_hash

          expect(hash[:userId]).to eq(user_id)

          expect(hash[:siren]).to eq('789510732')

          expect(hash[:groupeIS]).to eq('OUI')
          expect(hash[:membreIS]).to eq('FILLE')
          expect(hash[:code_postalIS]).to eq('75009')
          expect(hash[:raison_socialeIS]).to eq('DANONE')
          expect(hash[:adresseIS]).to eq('17 BD HAUSSMANN')
          expect(hash[:villeIS]).to eq('PARIS 9')
          expect(hash[:complementIS]).to be_nil

          expect(hash[:groupeTVA]).to eq('NON')
          expect(hash.dig(:membreTVA)).to be_nil
          expect(hash.dig(:code_postalTVA)).to be_nil
          expect(hash.dig(:raison_socialeTVA)).to be_nil
          expect(hash.dig(:adresseTVA)).to be_nil
          expect(hash.dig(:villeTVA)).to be_nil
          expect(hash.dig(:complementTVA)).to be_nil
        end
      end

      context 'when TVA is provided' do
        subject do
          described_class.new(
            {
              siren: siren,
              entreprise_tva: entreprise_tva,
              etablissement_tva: etablissement_tva,
              user_id: user_id
            }
          )
        end

        it { is_expected.to be_valid }

        it 'has all the keys' do
          hash = subject.to_hash

          expect(hash[:userId]).to eq(user_id)

          expect(hash[:siren]).to eq('789510732')

          expect(hash[:groupeTVA]).to eq('OUI')
          expect(hash[:membreTVA]).to eq('FILLE')
          expect(hash[:code_postalTVA]).to eq('75009')
          expect(hash[:raison_socialeTVA]).to eq('DANONE')
          expect(hash[:adresseTVA]).to eq('17 BD HAUSSMANN')
          expect(hash[:villeTVA]).to eq('PARIS 9')
          expect(hash[:complementTVA]).to be_nil

          expect(hash[:groupeIS]).to eq('NON')
          expect(hash.dig(:membreIS)).to be_nil
          expect(hash.dig(:code_postalIS)).to be_nil
          expect(hash.dig(:raison_socialeIS)).to be_nil
          expect(hash.dig(:adresseIS)).to be_nil
          expect(hash.dig(:villeIS)).to be_nil
          expect(hash.dig(:complementIS)).to be_nil
        end
      end
    end
  end
end
