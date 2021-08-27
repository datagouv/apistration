RSpec.describe UploadDocumentGenerator, type: :generator do
  let(:resource_name) { 'MODULE::ResourceName' }

  before { run_generator [resource_name] }

  describe 'UploadDocument class file' do
    subject { file('app/organizers/module/resource_name/upload_document.rb') }

    it { is_expected.to exist }
    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/class #{resource_name}::UploadDocument < UploadDocumentOrganizer/) }
    it { is_expected.to have_method 'source_file_content' }
    it { is_expected.to have_method 'file_type' }
    it { is_expected.to have_method 'filename' }
  end

  describe 'UploadDocument spec file' do
    subject { file('spec/organizers/module/resource_name/upload_document_spec.rb') }

    it { is_expected.to exist }
    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/RSpec.describe #{resource_name}::UploadDocument, :self_hosted_doc do/) }
  end
end
