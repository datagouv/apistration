RSpec.describe SIADE::SelfHostedDocument::Uploader do
  let(:pdf_content) { open_payload_file('pdf/dummy.pdf') }
  let(:pdf_filename) { 'random.lol' }

  describe '#url' do
    subject do
      doc = described_class.call(pdf_filename, pdf_content)
      URI(doc.url)
    end

    let(:timestamp_pattern)     { '[0-9]{10}' }
    let(:secure_token_pattern)  { '[0-9a-f]{40}' }

    its(:scheme)  { is_expected.to eq('https') }
    its(:host)    { is_expected.to eq(URI(Siade.credentials[:public_storage_url]).host) }
    its(:path)    { is_expected.to match(%r{\A/siade_dev/#{timestamp_pattern}-#{secure_token_pattern}-#{pdf_filename}\z}) }
  end
end
