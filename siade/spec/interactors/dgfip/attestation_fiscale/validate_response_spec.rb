RSpec.describe DGFIP::AttestationFiscale::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'DGFIP - Adélie') }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    context 'when body is a valid pdf' do
      let(:body) { Rails.root.join('spec/fixtures/pdfs/dgfip_attestations_fiscales/basic.pdf').read }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }

      its(:cacheable) { is_expected.to be(true) }
    end

    context 'when body is not a pdf' do
      let(:body) { 'lol' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

      its(:cacheable) { is_expected.to be(false) }
    end

    context 'when body is a pdf which specifies it is impossible to deliver the document' do
      let(:body) { Rails.root.join('spec/fixtures/pdfs/dgfip_attestations_fiscales/not_delivered.pdf').read }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

      its(:cacheable) { is_expected.to be(false) }
    end
  end

  context 'with a not found response' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

    its(:cacheable) { is_expected.to be(false) }
  end

  context 'with a 500 runtime error' do
    let(:response) { instance_double(Net::HTTPInternalServerError, code: '500', body:) }
    let(:body) { '{"erreur":{"code":303001,"message":"Runtime Error","horodatage":"2025-02-05T09:39:22+01:00"}}' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderTemporaryError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

    its(:cacheable) { is_expected.to be(false) }
  end
end
