require 'rails_helper'

RSpec.describe SIADE::V2::Drivers::SelfHostedDocumentDriver, type: :driver do
  subject { DummyHostedDocumentDriver.new.perform_request }

  before(:all) do
    class DummyHostedDocumentDriver < SIADE::V2::Drivers::GenericDriver
      include SIADE::V2::Drivers::SelfHostedDocumentDriver

      def provider_name
        'Dummy'
      end

      def request
        OpenStruct.new(
          http_code: 200,
          perform: nil,
          errors: []
        )
      end

      private

      def document_file_type
        SIADE::SelfHostedDocument::File::PDF
      end

      def document_name
        'attestation_vigilance_acoss'
      end

      def document_source
        File.read(Rails.root.join('spec/fixtures/dummy.pdf'))
      end

      def document_storage_method
        :store_from_binary
      end
    end
  end

  describe 'hosting service issues' do
    context 'when service is unavailable' do
      let(:error) { Excon::Error::ServiceUnavailable.new('whatever') }

      before do
        allow(SIADE::SelfHostedDocument::Uploader).to receive(:storage_shared_connexion).and_raise(error)
      end

      its(:http_code) { is_expected.to eq(502) }
      its(:errors) { is_expected.to include(instance_of(HostingServiceError)) }
    end
  end
end
