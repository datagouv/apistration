RSpec.describe EuropeanCommission::VIES, type: :retriever_organizer do
  subject(:make_call) { described_class.call(params:) }

  let(:params) do
    {
      siren:
    }
  end

  let(:siren) { danone_siren }
  let(:tva_number) { danone_tva_number }

  describe '.call' do
    let!(:stubbed_request) do
      stub_request(:get, "#{Siade.credentials[:european_commission_vies_url]}/#{tva_number[2..]}").to_return(
        status: 200,
        body:
      )
    end

    context 'when siren has a valid tva french number' do
      let(:body) { read_payload_file('vies/valid.json') }

      it { is_expected.to be_a_success }

      it 'calls the stubbed request' do
        make_call

        expect(stubbed_request).to have_been_requested
      end

      it 'retrieves the resource' do
        resource = make_call.bundled_data.data

        expect(resource).to be_present
      end
    end

    context 'when siren does not have a french tva number' do
      let(:body) { read_payload_file('vies/invalid.json') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end
  end
end
