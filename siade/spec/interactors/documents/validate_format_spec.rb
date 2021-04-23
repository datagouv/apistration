require 'rails_helper'

RSpec.describe Documents::ValidateFormat do
  subject { described_class.call(validation_params.merge(provider_name: provider_name)) }

  let(:provider_name) { 'INSEE' }

  let(:validation_params) do
    {
      file_type: 'pdf',
      content: file_content,
    }
  end

  describe '.call' do
    context 'with a valid content' do
      let(:file_content) { open_payload_file('pdf/dummy.pdf') }

      it { is_expected.to be_success }
    end

    context 'with an invalid content' do
      let(:file_content) { 'not a pdf' }

      it { is_expected.to be_failure }

      its(:errors) { is_expected.to have_error('File content is not in the expected `pdf` format.') }
    end
  end
end
