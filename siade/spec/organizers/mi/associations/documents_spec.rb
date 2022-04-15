RSpec.describe MI::Associations::Documents, type: :retrieve_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret_or_rna:
      }
    end

    context 'happy path', vcr: { cassette_name: 'rna_association/77571979202585' } do
      let(:siret_or_rna) { '77571979202585' }

      before do
        stub_request(:get, %r{jeunesse-sports\.gouv\.fr/cxf/api/documents/PJ})
          .to_return(body: open_payload_file('pdf/dummy.pdf'))
      end

      it { is_expected.to be_a_success }

      its(:resource_collection) { is_expected.to be_present }
    end
  end
end
