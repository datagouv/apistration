RSpec.describe MI::Associations::Documents, type: :retrieve_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret_or_rna:
      }
    end

    context 'when happy path', vcr: { cassette_name: 'mi/associations/documents/with_documents' } do
      let(:siret_or_rna) { '77571979202585' }

      before do
        stub_request(:get, %r{jeunesse-sports\.gouv\.fr/cxf/api/documents/PJ})
          .to_return(body: open_payload_file('pdf/dummy.pdf'))
      end

      it { is_expected.to be_a_success }

      its(:resource_collection) { is_expected.to be_present }
    end

    describe 'non regression test' do
      context 'when association retrievers returns a hash instead of an array for asso->documents->document_rna', vcr: { cassette_name: 'mi/associations/documents/no_documents_key' } do
        let(:siret_or_rna) { '41763950700017' }

        it { is_expected.to be_a_success }
      end
    end
  end
end
