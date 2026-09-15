RSpec.describe DGDDI::EORI, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret_or_eori:
      }
    end

    let(:resource) { subject.bundled_data.data }

    context 'with valid eori' do
      let(:siret_or_eori) { valid_eori }

      before { stub_dgddi_valid_eori }

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        expect(resource).to be_present
      end
    end

    context 'with valid spanish eori' do
      let(:siret_or_eori) { valid_spanish_eori }

      before { stub_dgddi_valid_spanish_eori }

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        expect(resource).to be_present
      end
    end

    context 'with invalid eori' do
      let(:siret_or_eori) { invalid_eori }

      it { is_expected.to be_a_failure }
    end
  end
end
