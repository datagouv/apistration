RSpec.describe SIADE::V2::Drivers::INPI::Actes, type: :provider_driver do
  subject(:driver) do
    described_class.new(siren: siren, cookie: valid_cookie_inpi).tap(&:perform_request)
  end

  context 'when siren is not found', vcr: { cassette_name: 'inpi_actes_not_found' } do
    let(:siren) { not_found_siren(:inpi) }

    its(:http_code) { is_expected.to eq 404 }
  end

  context 'with existing siren', vcr: { cassette_name: 'inpi_actes_valid_siren' } do
    let(:siren) { valid_siren(:inpi_pdf) }

    its(:http_code) { is_expected.to eq 200 }

    describe 'results' do
      subject { driver.actes }

      it { is_expected.to be_an(Array) }

      it 'has a valid payload' do
        expect(subject).to include(
          id_fichier: Integer,
          siren: String,
          denomination_sociale: nil,
          code_greffe: Integer,
          date_depot: String,
          nature_archive: a_string_matching(/(A|R|P)/)
        )
      end
    end

    describe 'first result' do
      subject { driver.actes.first }

      it 'has expected payload' do
        expect(subject).to include(
          id_fichier: 212_007_233,
          siren: '393463187',
          denomination_sociale: nil,
          code_greffe: 3801,
          date_depot: '20050112',
          nature_archive: 'A'
        )
      end
    end
  end
end
