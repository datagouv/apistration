RSpec.describe Infogreffe::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response:, provider_name: 'Infogreffe') }

    let(:response) do
      instance_double(Net::HTTPOK, code:, body:)
    end

    let(:xml_open_tags) do
      '<SOAP-ENV:Envelope ' \
        "xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' " \
        "xmlns:SOAP-ENC='http://schemas.xmlsoap.org/soap/encoding/' " \
        "xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' " \
        "xmlns:xsd='http://www.w3.org/2001/XMLSchema'>" \
        '<SOAP-ENV:Body>' \
        '<ns0:getProduitsWebServicesXMLResponse ' \
        "xmlns:ns0='urn:local' SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'> " \
        "<return xsi:type='xsd:string'>"
    end
    let(:xml_close_tags) do
      '</return>' \
        '</ns0:getProduitsWebServicesXMLResponse>' \
        '</SOAP-ENV:Body>' \
        '</SOAP-ENV:Envelope>'
    end

    describe 'with an invalid code' do
      let(:code) { '418' }
      let(:body) { 'A body' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'with a valid code and a valid xml' do
      let(:code) { '200' }

      let(:body) { "#{xml_open_tags}<Extrait type=\"2\"><num_ident siren=\"418166096\"/></Extrait>#{xml_close_tags}" }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'with a valid code and a body containing NotFound message' do
      let(:code) { '200' }

      context 'with 006 error' do
        let(:body) { "#{xml_open_tags}006 -DOSSIER NON TROUVE DANS LA BASE DE GREFFES-#{xml_close_tags}" }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end

      context 'with 008 error' do
        let(:body) { "#{xml_open_tags}008 -KBIS INDISPONIBLE POUR LE SIREN-#{xml_close_tags}" }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end
    end

    context 'with a valid code and a body containing Service Indisponible' do
      let(:code) { '200' }

      let(:body) { "#{xml_open_tags}999 -SERVICE INDISPONIBLE-#{xml_close_tags}" }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnavailable)) }
    end

    context 'with a valid code and a body containing nonsense' do
      let(:code) { '200' }
      let(:body) { 'Nonsense' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end
end
