RSpec.describe UploadDocumentOrganizer, type: :organizer do
  describe '.call' do
    context 'when not specifying expiration time' do
      subject { DummyUploadDocumentOrganizer1.call }

      before do
        class DummyUploadDocumentOrganizer1 < UploadDocumentOrganizer
          def source_file_content
            'dummy_source_file'
          end

          def file_type
            'dummy_file_type'
          end

          def filename
            'dummy_filename'
          end
        end
      end

      its(:content) { is_expected.to eq 'dummy_source_file' }
      its(:file_type) { is_expected.to eq 'dummy_file_type' }
      its(:filename) { is_expected.to eq 'dummy_filename' }
      its(:expires_in) { is_expected.to eq 1.day.to_i }
    end

    context 'when specifying a different expiration time' do
      subject { DummyUploadDocumentOrganizer2.call }

      before do
        class DummyUploadDocumentOrganizer2 < UploadDocumentOrganizer
          def source_file_content
            'dummy_source_file'
          end

          def file_type
            'dummy_file_type'
          end

          def filename
            'dummy_filename'
          end

          def expires_in
            1.hour.to_i
          end
        end
      end

      its(:expires_in) { is_expected.to eq 1.hour.to_i }
    end
  end
end
