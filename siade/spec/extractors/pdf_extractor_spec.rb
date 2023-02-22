require 'rails_helper'

RSpec.describe PDFExtractor, type: :extractor do
  before(:all) do
    class DummyPDFExtractor < PDFExtractor
      def extract
        pdf_reader.pages.first.text
      end
    end
  end

  describe '#perform' do
    subject { DummyPDFExtractor.new(pdf_io).perform }

    context 'when the pdf is valid' do
      let(:pdf_io) { Rails.root.join('spec/fixtures/dummy.pdf').read }

      it { is_expected.to eq('Dummy PDF file') }
    end

    context 'when the pdf is invalid' do
      let(:pdf_io) { Rails.root.join('spec/fixtures/dummy.jpg').read }

      it 'raises an error' do
        expect { subject }.to raise_error(PDFExtractor::InvalidFile)
      end
    end
  end
end
