RSpec.describe SIADE::V3::Referentials::TrancheEffectifSalarie do
  subject { described_class.new(code: code, date_reference: date_reference) }

  context 'with nil code' do
    let(:code) { nil }
    let(:date_reference) { nil }

    its(:valid?) { is_expected.to be_falsey }
    its(:found?) { is_expected.to be_falsey }
    its(:de) { is_expected.to be_nil }
    its(:a) { is_expected.to be_nil }
    its(:intitule) { is_expected.to be_nil }
    its(:code) { is_expected.to be_nil }
    its(:date_reference) { is_expected.to be_nil }

    it 'does not logs a deprecated data through MonitoringService' do
      expect(MonitoringService.instance).not_to receive(:track_deprecated_data)

      subject.intitule
    end
  end

  context 'with not found code' do
    let(:code) { '99' }
    let(:date_reference) { '2018' }

    its(:valid?) { is_expected.to be_truthy }
    its(:found?) { is_expected.to be_falsey }
    its(:de) { is_expected.to be_nil }
    its(:a) { is_expected.to be_nil }
    its(:intitule) { is_expected.to eq 'non référencé' }
    its(:code) { is_expected.to eq code }
    its(:date_reference) { is_expected.to eq date_reference }

    its(:as_json) { is_expected.to match_json_schema('insee/v3/tranche_effectif_salarie') }

    it 'logs a deprecated data through MonitoringService' do
      expect(MonitoringService.instance).to receive(:track_deprecated_data).with(
        'Tranche effectif salarie',
        code,
      )

      subject.intitule
    end
  end

  shared_examples 'with invalid code' do |code|
    let(:code) { code }
    let(:date_reference) { '2018' }

    its(:valid?) { is_expected.to be_falsey }
    its(:found?) { is_expected.to be_falsey }
    its(:de) { is_expected.to be_nil }
    its(:a) { is_expected.to be_nil }
    its(:intitule) { is_expected.to eq 'non référencé' }
    its(:code) { is_expected.to eq code }
    its(:date_reference) { is_expected.to eq date_reference }

    # Will not match json schema because of wrong code...

    it 'logs a deprecated data through MonitoringService' do
      expect(MonitoringService.instance).to receive(:track_deprecated_data).with(
        'Tranche effectif salarie',
        code,
      )

      subject.intitule
    end
  end

  it_behaves_like 'with invalid code', '9000'
  it_behaves_like 'with invalid code', '0'
  it_behaves_like 'with invalid code', '1'
  it_behaves_like 'with invalid code', '900'

  context 'with NN code' do
    let(:code) { 'NN' }
    let(:date_reference) { '2018' }

    its(:valid?) { is_expected.to be_truthy }
    its(:found?) { is_expected.to be_truthy }
    its(:de) { is_expected.to be_nil }
    its(:a) { is_expected.to be_nil }
    its(:intitule) { is_expected.to eq 'Unités non employeuses' }
    its(:code) { is_expected.to eq code }
    its(:date_reference) { is_expected.to eq date_reference }

    its(:as_json) { is_expected.to match_json_schema('insee/v3/tranche_effectif_salarie') }
  end

  context 'with 00 code' do
    let(:code) { '00' }
    let(:date_reference) { '2018' }

    its(:valid?) { is_expected.to be_truthy }
    its(:found?) { is_expected.to be_truthy }
    its(:de) { is_expected.to eq 0 }
    its(:a) { is_expected.to eq 0 }
    its(:intitule) { is_expected.to eq '0 salarié' }
    its(:code) { is_expected.to eq code }
    its(:date_reference) { is_expected.to eq date_reference }

    its(:as_json) { is_expected.to match_json_schema('insee/v3/tranche_effectif_salarie') }
  end

  context 'with 31 code' do
    let(:code) { '31' }
    let(:date_reference) { '2018' }

    its(:valid?) { is_expected.to be_truthy }
    its(:found?) { is_expected.to be_truthy }
    its(:de) { is_expected.to eq 200 }
    its(:a) { is_expected.to eq 249 }
    its(:intitule) { is_expected.to eq '200 à 249 salariés' }
    its(:code) { is_expected.to eq code }
    its(:date_reference) { is_expected.to eq date_reference }

    its(:as_json) { is_expected.to match_json_schema('insee/v3/tranche_effectif_salarie') }
  end
end
