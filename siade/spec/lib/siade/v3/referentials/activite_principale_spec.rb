RSpec.describe SIADE::V3::Referentials::ActivitePrincipale do
  subject { described_class.new(code: code, nomenclature: nomenclature) }

  describe 'nomenclature not found' do
    let(:nomenclature) { 'not_found' }
    let(:code) { '9999' }

    its(:valid?) { is_expected.to be_falsey }
    its(:found?) { is_expected.to be_falsey }
    its(:libelle) { is_expected.to eq 'ancienne révision NAF (not_found) non supportée' }
    its(:code) { is_expected.to eq code }
    its(:code_dotless) { is_expected.to eq code }
    its(:nomenclature) { is_expected.to eq nomenclature }

    # it doesn't match json schema because of unkown nomenclature
  end

  shared_examples 'with invalid code' do |code_activite_principale|
    let(:code) { code_activite_principale }

    its(:valid?) { is_expected.to be_falsey }
    its(:found?) { is_expected.to be_falsey }
    its(:libelle) { is_expected.to eq 'non référencé' }
    its(:code) { is_expected.to eq code }
    its(:code_dotless) { is_expected.to eq code&.delete('.') }
    its(:nomenclature) { is_expected.to eq nomenclature }

    its(:as_json) { is_expected.to match_json_schema('insee/v3/naf') }

    it 'logs a deprecated data through MonitoringService' do
      expect(MonitoringService.instance).to receive(:track_deprecated_data).with(
        nomenclature,
        code
      )

      subject.libelle
    end
  end

  shared_examples 'with code not found' do |code_activite_principale|
    let(:code) { code_activite_principale }

    its(:valid?) { is_expected.to be_truthy }
    its(:found?) { is_expected.to be_falsey }
    its(:libelle) { is_expected.to eq 'non référencé' }
    its(:code) { is_expected.to eq code }
    its(:code_dotless) { is_expected.to eq code&.delete('.') }
    its(:nomenclature) { is_expected.to eq nomenclature }

    its(:as_json) { is_expected.to match_json_schema('insee/v3/naf') }

    it 'logs a deprecated data through MonitoringService' do
      expect(MonitoringService.instance).to receive(:track_deprecated_data).with(
        nomenclature,
        code
      )

      subject.libelle
    end
  end

  describe 'nomenclature NAF Rev2' do
    let(:nomenclature) { 'NAFRev2' }

    # 01.50Z exists
    it_behaves_like 'with invalid code', '01.50'
    it_behaves_like 'with invalid code', '0150Z'
    it_behaves_like 'with invalid code', '01.50ZA'
    it_behaves_like 'with invalid code', nil

    it_behaves_like 'with code not found', '17.21D'

    context 'with 01.50Z code' do
      let(:code) { '01.50Z' }

      its(:valid?) { is_expected.to be_truthy }
      its(:found?) { is_expected.to be_truthy }
      its(:libelle) { is_expected.to eq 'Culture et élevage associés' }
      its(:code) { is_expected.to eq code }
      its(:code_dotless) { is_expected.to eq '0150Z' }
      its(:nomenclature) { is_expected.to eq nomenclature }

      its(:as_json) { is_expected.to match_json_schema('insee/v3/naf') }
    end

    context 'with 13.94Z code (with , in libelle)' do
      let(:code) { '13.94Z' }

      its(:valid?) { is_expected.to be_truthy }
      its(:found?) { is_expected.to be_truthy }
      its(:libelle) { is_expected.to eq 'Fabrication de ficelles, cordes et filets' }
      its(:code) { is_expected.to eq code }
      its(:code_dotless) { is_expected.to eq '1394Z' }
      its(:nomenclature) { is_expected.to eq nomenclature }

      its(:as_json) { is_expected.to match_json_schema('insee/v3/naf') }
    end

    context 'with 17.21A code (with \' in libelle)' do
      let(:code) { '17.21C' }

      its(:valid?) { is_expected.to be_truthy }
      its(:found?) { is_expected.to be_truthy }
      its(:libelle) { is_expected.to eq 'Fabrication d\'emballages en papier' }
      its(:code) { is_expected.to eq code }
      its(:code_dotless) { is_expected.to eq '1721C' }
      its(:nomenclature) { is_expected.to eq nomenclature }

      its(:as_json) { is_expected.to match_json_schema('insee/v3/naf') }
    end

    context 'with 00.00Z code (not in Rev2 but exists...)' do
      let(:code) { '00.00Z' }

      its(:valid?) { is_expected.to be_truthy }
      its(:found?) { is_expected.to be_truthy }
      its(:libelle) { is_expected.to eq 'En instance de chiffrement' }
      its(:code) { is_expected.to eq code }
      its(:code_dotless) { is_expected.to eq '0000Z' }
      its(:nomenclature) { is_expected.to eq nomenclature }

      its(:as_json) { is_expected.to match_json_schema('insee/v3/naf') }
    end
  end
end
