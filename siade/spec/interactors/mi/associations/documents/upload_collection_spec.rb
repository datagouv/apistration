RSpec.describe MI::Associations::Documents::UploadCollection do
  describe '.call' do
    subject { described_class.call(response:) }

    let(:response) { instance_double(Net::HTTPOK, body:) }
    let(:body) do
      '<asso>' \
        '<documents>' \
        '<nbDocRna>' \
        '2' \
        '</nbDocRna>' \
        '<document_rna>' \
        '<id>very_id_1</id>' \
        '<type>PIECE</type>' \
        '<annee>2014</annee>' \
        '<sous_type>DCR</sous_type>' \
        '<even>5248133</even>' \
        '<time>1418807656</time>' \
        '<url>https://much.url/doc_1</url>' \
        '<lib_sous_type>Décret</lib_sous_type>' \
        '</document_rna>' \
        '<document_rna>' \
        '<id>much_id_2</id>' \
        '<type>PIECE</type>' \
        '<annee>2014</annee>' \
        '<sous_type>STC</sous_type>' \
        '<even>5248133</even>' \
        '<time>1418807674</time>' \
        '<url>https://another.url/great</url>' \
        '<lib_sous_type>Statuts</lib_sous_type>' \
        '</document_rna>' \
        '</documents>' \
        '</asso>'
    end

    before do
      allow(MI::Associations::Documents::Upload).to receive(:call)
        .and_return(first_uploader, second_uploader)
    end

    # rubocop:disable RSpec/VerifiedDoubles

    context 'when upload is valid for all documents' do
      let(:first_uploader) { double('uploader', success?: true, url: 'first_url', url_expires_in: 1.day.to_i) }
      let(:second_uploader) { double('uploader', success?: true, url: 'second_url', url_expires_in: 3.days.to_i) }

      it { is_expected.to be_a_success }

      # rubocop:disable Metrics/BlockLength
      it 'keeps the entire collection data and adds the self hosted URL' do
        expect(subject.uploaded_collection).to contain_exactly(
          {
            id: 'very_id_1',
            type: 'PIECE',
            annee: '2014',
            sous_type: 'DCR',
            even: '5248133',
            time: '1418807656',
            url: 'https://much.url/doc_1',
            lib_sous_type: 'Décret',
            hosted_url: 'first_url',
            url_expires_in: 1.day.to_i,
            errors: []
          },
          {
            id: 'much_id_2',
            type: 'PIECE',
            annee: '2014',
            sous_type: 'STC',
            even: '5248133',
            time: '1418807674',
            url: 'https://another.url/great',
            lib_sous_type: 'Statuts',
            hosted_url: 'second_url',
            url_expires_in: 3.days.to_i,
            errors: []
          }
        )
      end
      # rubocop:enable Metrics/BlockLength

      its(:total_documents) { is_expected.to eq(2) }
      its(:upload_errors) { is_expected.to eq(0) }
    end

    context 'when upload fails for at least one documents' do
      let(:first_uploader) { double('uploader', success?: true, url: 'first_url', url_expires_in: 1.day.to_i) }
      let(:second_uploader) { double('uploader', success?: false, errors:) }

      let(:errors) do
        [
          BadFileFromProviderError.new('Much provider', :invalid_url, 'very error')
        ]
      end

      it { is_expected.to be_a_success }

      it 'keeps the successful upload data' do
        expect(subject.uploaded_collection).to include(
          {
            id: 'very_id_1',
            type: 'PIECE',
            annee: '2014',
            sous_type: 'DCR',
            even: '5248133',
            time: '1418807656',
            url: 'https://much.url/doc_1',
            lib_sous_type: 'Décret',
            hosted_url: 'first_url',
            url_expires_in: 1.day.to_i,
            errors: []
          }
        )
      end

      it 'keeps the document errors metadata' do
        expect(subject.uploaded_collection).to include(
          {
            id: 'much_id_2',
            type: 'PIECE',
            annee: '2014',
            sous_type: 'STC',
            even: '5248133',
            time: '1418807674',
            url: 'https://another.url/great',
            lib_sous_type: 'Statuts',
            hosted_url: nil,
            url_expires_in: nil,
            errors: ['very error']
          }
        )
      end

      its(:total_documents) { is_expected.to eq(2) }
      its(:upload_errors) { is_expected.to eq(1) }
    end

    # rubocop:enable RSpec/VerifiedDoubles
  end
end
