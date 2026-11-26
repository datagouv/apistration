RSpec.describe Infogreffe::MakeRequest, type: :make_request do
  subject { described_class.call(params:, version_schema:) }

  let(:version_schema) { nil }

  let(:siren) { valid_siren(:extrait_rcs) }
  let(:params) { { siren: } }

  let(:expected_request_body) do
    format(
      open_payload_file('infogreffe/kbis_request.xml').read,
      code_abonne: Siade.credentials[:infogreffe_code_abonne],
      mot_passe: Siade.credentials[:infogreffe_mot_passe],
      siren:
    )
  end

  describe 'happy path' do
    before { stub_infogreffe_extrait_rcs(siren:, payload: 'personne_morale') }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'sends the SOAP request Infogreffe expects, with the subscriber credentials' do
      subject

      expect(
        a_request(:post, Siade.credentials[:infogreffe_url_extrait_rcs])
          .with(headers: { 'Content-Type' => 'text/xml', 'Charset' => 'utf-8', 'SOAPAction' => 'getProduitsWebServicesXML' }) do |request|
            XmlSimple.xml_in(request.body) == XmlSimple.xml_in(expected_request_body)
          end
      ).to have_been_made
    end
  end

  describe 'with a schema version' do
    let(:version_schema) { 14 }

    before { stub_infogreffe_extrait_rcs_schema_14(siren:, payload: 'personne_morale') }

    it 'asks Infogreffe for this schema version' do
      subject

      expect(
        a_request(:post, Siade.credentials[:infogreffe_url_extrait_rcs])
          .with(body: %r{<demande>\s*<version_schema>14</version_schema>})
      ).to have_been_made
    end
  end
end
