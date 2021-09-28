RSpec.describe SIADE::V2::Referentials::CategorieJuridique do
  subject { described_class.new(code: code) }

  context 'with not found code' do
    let(:code) { '9999' }

    its(:valid?) { is_expected.to be_truthy }
    its(:found?) { is_expected.to be_falsey }
    its(:libelle) { is_expected.to eq 'non référencé' }
    its(:code) { is_expected.to eq code }

    its(:as_json) { is_expected.to match_json_schema('insee/v3/forme_juridique') }

    it 'logs a deprecated data through MonitoringService' do
      expect(MonitoringService.instance).to receive(:track_deprecated_data).with(
        'Categorie Juridique',
        code
      )

      subject.libelle
    end
  end

  shared_examples 'with invalid code' do |code_categorie_juridique|
    let(:code) { code_categorie_juridique }

    its(:valid?) { is_expected.to be_falsey }
    its(:found?) { is_expected.to be_falsey }
    its(:libelle) { is_expected.to eq 'non référencé' }
    its(:code) { is_expected.to eq code }

    # will not match json schema because of wrong code

    it 'logs a deprecated data through MonitoringService' do
      expect(MonitoringService.instance).to receive(:track_deprecated_data).with(
        'Categorie Juridique',
        code
      )

      subject.libelle
    end
  end

  it_behaves_like 'with invalid code', '12'
  it_behaves_like 'with invalid code', '12345'

  context 'with 1000 code' do
    let(:code) { '1000' }

    its(:valid?) { is_expected.to be_truthy }
    its(:found?) { is_expected.to be_truthy }
    its(:libelle) { is_expected.to eq 'Entrepreneur individuel' }
    its(:code) { is_expected.to eq code }

    its(:as_json) { is_expected.to match_json_schema('insee/v3/forme_juridique') }
  end

  context 'with 5710 code (with , in libelle)' do
    let(:code) { '5710' }

    its(:valid?) { is_expected.to be_truthy }
    its(:found?) { is_expected.to be_truthy }
    its(:libelle) { is_expected.to eq 'SAS, société par actions simplifiée' }
    its(:code) { is_expected.to eq code }

    its(:as_json) { is_expected.to match_json_schema('insee/v3/forme_juridique') }
  end

  context 'with 6100 code (with \' in libelle)' do
    let(:code) { '6100' }

    its(:valid?) { is_expected.to be_truthy }
    its(:found?) { is_expected.to be_truthy }
    its(:libelle) { is_expected.to eq 'Caisse d\'Épargne et de Prévoyance' }
    its(:code) { is_expected.to eq code }

    its(:as_json) { is_expected.to match_json_schema('insee/v3/forme_juridique') }
  end
end
