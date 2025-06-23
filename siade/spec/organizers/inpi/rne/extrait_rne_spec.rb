RSpec.describe INPI::RNE::ExtraitRNE, type: :retriever_organizer do
  describe '.call', vcr: { cassette_name: 'inpi/rne/authenticate' } do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren:
      }
    end

    context 'with invalid siren' do
      let(:siren) { '123456789' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }

      its(:cacheable) { is_expected.to be(false) }
    end

    context 'with valid siren' do
      let(:siren) { valid_siren }

      context 'when RNE renders a valid response' do
        before do
          stub_request(:get, "#{Siade.credentials[:inpi_rne_url]}/api/companies/#{siren}").and_return(
            status: 200,
            body: read_payload_file('inpi/rne/extrait_rne/valid.json')
          )
        end

        it { is_expected.to be_a_success }

        it 'retrieves the resource' do
          resource = subject.bundled_data.data

          expect(resource).to be_present
        end

        its(:errors) { is_expected.to be_blank }
        its(:cacheable) { is_expected.to be(true) }
      end

      context 'when RNE renders a not found response' do
        before do
          stub_request(:get, "#{Siade.credentials[:inpi_rne_url]}/api/companies/#{siren}").and_return(
            status: 404
          )
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
        its(:cacheable) { is_expected.to be(false) }
      end
    end
  end
end
