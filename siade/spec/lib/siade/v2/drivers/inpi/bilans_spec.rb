RSpec.describe SIADE::V2::Drivers::INPI::Bilans, type: :provider_driver do
  subject(:driver) do
    described_class.new(siren: siren, cookie: valid_cookie_inpi).tap(&:perform_request)
  end

  context 'when siren is not found', vcr: { cassette_name: 'inpi_bilans_not_found' } do
    let(:siren) { not_found_siren(:inpi) }

    its(:http_code) { is_expected.to eq 404 }
  end

  context 'with existing siren', vcr: { cassette_name: 'inpi_bilans_valid_siren' } do
    let(:siren) { valid_siren(:inpi) }

    its(:http_code) { is_expected.to eq 200 }

    describe 'results' do
      subject { driver.bilans }

      it { is_expected.to be_an(Array) }

      it 'has a valid payload' do
        expect(subject).to include(
          id_fichier:           Integer,
          siren:                String,
          denomination_sociale: nil,
          code_greffe:          Integer,
          date_depot:           String,
          nature_archive:       a_string_matching(/(B-C|B-S|B-CO|B-BA)/),
          confidentiel:         be_between(0, 2),
          date_cloture:         String,
          numero_gestion:       String
        )
      end
    end

    describe 'first result' do
      subject { driver.bilans.first }

      it 'has expected payload' do
        expect(subject).to include(
          id_fichier:           12413137,
          siren:                '542065479',
          denomination_sociale: nil,
          code_greffe:          7803,
          date_depot:           '20180816',
          nature_archive:       'B-S',
          confidentiel:         0,
          date_cloture:         '2017-12-31T00:00:00.000Z',
          numero_gestion:       '1999B00360'
        )
      end
    end
  end
end
