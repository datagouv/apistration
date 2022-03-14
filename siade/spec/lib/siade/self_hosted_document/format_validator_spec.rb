RSpec.describe SIADE::SelfHostedDocument::FormatValidator do
  subject { validator.valid?(file_io) }

  let(:validator) { described_class.new(file_type) }

  describe 'PDF validation' do
    let(:file_type) { :pdf }

    context 'with a valid PDF' do
      let(:file_io) { read_payload_file('pdf/dummy.pdf') }

      it { is_expected.to be(true) }
    end

    context 'with a wrong formatted PDF' do
      let(:file_io) { 'not a pdf' }

      it { is_expected.to be(false) }
    end
  end

  describe 'ZIP validation' do
    let(:file_type) { :zip }

    context 'with a valid ZIP' do
      let(:file_io) { read_payload_file('zip/dummy.zip') }

      it { is_expected.to be(true) }
    end

    context 'with a wrong formatted ZIP' do
      let(:file_io) { 'not a zip' }

      it { is_expected.to be(false) }
    end
  end
end
