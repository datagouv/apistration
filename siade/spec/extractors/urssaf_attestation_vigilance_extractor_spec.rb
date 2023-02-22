RSpec.describe URSSAFAttestationVigilanceExtractor, type: :extractor do
  describe '#perform' do
    subject { described_class.new(pdf_content).perform }

    let(:pdf_content) { Rails.root.join(pdf_path).read }

    context 'with valid files' do
      let(:pdf_path) { "spec/support/urssaf_attestations_sociales/#{kind}.pdf" }

      describe 'with basic pdf' do
        let(:kind) { :basic }

        it do
          expect(subject).to eq({
            code_securite: '8TFYQDUKZVQ5BIA',
            date_debut_validite: Date.new(2022, 12, 31)
          })
        end
      end

      describe 'with a pdf which has multiple pages (and blank one)' do
        let(:kind) { :valid_multiple_extra_pages }

        it do
          expect(subject).to eq({
            code_securite: 'GB1W15TAFJJEX1O',
            date_debut_validite: Date.new(2023, 1, 31)
          })
        end
      end

      describe 'with micro entreprise libérale pdf' do
        let(:kind) { :micro_entreprise_liberal }

        it do
          expect(subject).to eq({
            code_securite: 'KCT3ZDTCBLMHIEK',
            date_debut_validite: Date.new(2022, 12, 31)
          })
        end
      end

      describe 'hospital which has a wrong period (bug on urssaf side)' do
        let(:kind) { :hospital_bug_on_period }

        it do
          expect(subject).to eq({
            code_securite: 'GG4U3QT3OJBWOKT',
            date_debut_validite: Date.new(2023, 2, 17)
          })
        end
      end
    end

    context 'with invalid pdf' do
      let(:pdf_path) { 'spec/fixtures/dummy.pdf' }

      it { expect { subject }.to raise_error(URSSAFAttestationVigilanceExtractor::InvalidAttestationVigilance) }
    end
  end
end
