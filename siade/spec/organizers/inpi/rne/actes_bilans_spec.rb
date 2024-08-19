RSpec.describe INPI::RNE::ActesBilans, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:,
      token_id: 'token_id'
    }
  end

  context 'with valid siren', vcr: { cassette_name: 'inpi/rne/authenticate' } do
    let(:siren) { valid_siren(:inpi) }

    before { stub_inpi_rne_actes_bilans_valid(siren:) }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { described_class.call(params:).bundled_data.data }

      it { is_expected.to be_present }

      it { is_expected.to be_a(Resource) }

      describe 'links in resources' do
        subject(:link) { described_class.call(params:).bundled_data.data.actes.first[:link] }

        it { is_expected.to be_present }

        describe 'following link', type: :request, vcr: { cassette_name: 'inpi/rne/actes_download/valid' } do
          subject { response }

          let(:document_url_regexp) { %r{http://test\.entreprise\.api\.gouv\.fr/proxy/files/[a-f0-9\-]{36}} }

          before do
            get link
          end

          it { is_expected.to be_successful }

          it 'returns a proxy link to download the document' do
            expect(response.parsed_body[:data][:document_url]).to match(document_url_regexp)
          end
        end
      end
    end
  end
end
