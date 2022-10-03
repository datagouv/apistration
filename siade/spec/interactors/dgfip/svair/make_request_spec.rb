RSpec.describe DGFIP::SVAIR::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:, provider_name: 'DGFIP - SVAIR') }

  let(:params) do
    {
      tax_number:,
      tax_notice_number:
    }
  end

  let(:tax_number) { '1234567890ABC' }
  let(:tax_notice_number) { '1234567890ABC' }

  context 'when everything works' do
    let!(:stubbed_request) do
      stub_request(:post, 'https://cfsmsp.impots.gouv.fr/secavis/faces/commun/index.jsf').with(
        body: {
          'j_id_7:spi' => tax_number,
          'j_id_7:num_facture' => tax_notice_number,
          'j_id_7:j_id_l' => 'Valider',
          'j_id_7_SUBMIT' => '1',
          'javax.faces.ViewState' => 'view_state_value'
        }
      ).to_return(
        status: 200,
        body: Rails.root.join('spec/fixtures/payloads/dgfip/svair/valid_response_one_declarant.html').read
      )
    end

    before do
      mock_dgfip_svair_view_state
    end

    it { is_expected.to be_a_success }

    it 'calls svair with valid params' do
      make_call

      expect(stubbed_request).to have_been_requested
    end
  end

  context 'when view state value can not be parsed' do
    before do
      mock_dgfip_svair_view_state(payload: 'invalid')
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
