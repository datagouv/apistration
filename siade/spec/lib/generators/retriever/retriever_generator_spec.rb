RSpec.describe RetrieverGenerator, type: :generator do
  let(:resource_name) { 'MODULE::ResourceName' }

  describe 'RetrieverOrganizer class file' do
    subject { file('app/organizers/module/resource_name.rb') }

    shared_examples 'a valid RetrieverOrganizer' do
      it { is_expected.to have_correct_syntax }
      it { is_expected.to contain(/class #{resource_name} < RetrieverOrganizer/) }
      it { is_expected.to have_method 'provider_name' }
    end

    context 'with option: --validation_type SIREN' do
      before { run_generator [resource_name, '--validation_type', 'siren'] }

      it_behaves_like 'a valid RetrieverOrganizer'
      it { is_expected.to contain(/organize ValidateSiren/) }
    end

    context 'with option: --validation_type SIRET' do
      before { run_generator [resource_name, '--validation_type', 'siret'] }

      it_behaves_like 'a valid RetrieverOrganizer'
      it { is_expected.to contain(/organize ValidateSiret/) }
    end

    context 'with option: --validation_type CUSTOM' do
      before { run_generator [resource_name, '--validation_type', 'custom'] }

      it_behaves_like 'a valid RetrieverOrganizer'
      it { is_expected.to contain(/organize #{resource_name}::ValidateParams/) }
    end

    context 'without option: --validation_type' do
      before { run_generator [resource_name] }

      it_behaves_like 'a valid RetrieverOrganizer'
      it { is_expected.to contain(/organize ValidateSiren/) }
    end

    context 'with option: --document false' do
      before { run_generator [resource_name, '--document', 'false'] }

      it_behaves_like 'a valid RetrieverOrganizer'
      it { is_expected.not_to contain(/UploadDocument/) }
    end

    context 'with option: --document true' do
      before { run_generator [resource_name, '--document', 'true'] }

      it_behaves_like 'a valid RetrieverOrganizer'
      it { is_expected.to contain(/#{resource_name}::UploadDocument/) }
    end

    context 'without option: --document' do
      before { run_generator [resource_name] }

      it_behaves_like 'a valid RetrieverOrganizer'
      it { is_expected.not_to contain(/UploadDocument/) }
    end

    context 'without option: --prochainement' do
      before { run_generator [resource_name, '--prochainement', 'false'] }

      it_behaves_like 'a valid RetrieverOrganizer'
      it { is_expected.to contain(/ValidateResponse/) }
    end
  end

  describe 'RetrieverOrganizer spec file' do
    subject { file('spec/organizers/module/resource_name_spec.rb') }

    before { run_generator [resource_name] }

    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/RSpec.describe #{resource_name}, type: :retriever_organizer do/) }
  end
end
