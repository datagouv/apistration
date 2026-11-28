require 'rails_helper'

RSpec.describe PDFExtractor, type: :extractor do
  before(:all) do
    class DummyPDFExtractor < PDFExtractor
      def extract
        pdf_reader.pages.first.text
      end
    end

    class BuggyPDFExtractor < PDFExtractor
      def extract
        pages.first.text.undefined_extraction_step
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

    context 'when the extraction code itself is broken' do
      subject { BuggyPDFExtractor.new(Rails.root.join('spec/fixtures/dummy.pdf').read).perform }

      it 'lets the error surface instead of blaming the file' do
        expect { subject }.to raise_error(NoMethodError, /undefined_extraction_step/)
      end
    end
  end
end
