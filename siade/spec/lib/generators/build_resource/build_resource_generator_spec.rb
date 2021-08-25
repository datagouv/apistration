RSpec.describe BuildResourceGenerator, type: :generator do
  include_context 'with generator'

  let(:resource_name) { 'MODULE::ResourceName' }

  describe 'ValidateParam class file' do
    subject { file('app/interactors/module/resource_name/build_resource.rb') }

    shared_examples 'a valid BuildResource' do
      it { is_expected.to exist }
      it { is_expected.to have_correct_syntax }
    end

    context 'without any option' do
      before { run_generator [resource_name] }

      it_behaves_like 'a valid BuildResource'
      it { is_expected.to contain(/class #{resource_name}::BuildResource < BuildResource/) }
      it { is_expected.to have_method 'resource_attributes' }
    end

    context 'with option: --document false' do
      before { run_generator [resource_name, '--document', 'false'] }

      it_behaves_like 'a valid BuildResource'
      it { is_expected.to contain(/class #{resource_name}::BuildResource < BuildResource/) }
      it { is_expected.to have_method 'resource_attributes' }
    end

    context 'with option: --document true' do
      before { run_generator [resource_name, '--document', 'true'] }

      it_behaves_like 'a valid BuildResource'
      it { is_expected.to contain(/class #{resource_name}::BuildResource < BuildResource::Document/) }
      it { is_expected.to have_method 'id' }
    end
  end

  describe 'ValidateParam spec file' do
    subject { file('spec/interactors/module/resource_name/build_resource_spec.rb') }

    before { run_generator [resource_name] }

    it { is_expected.to exist }
    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/RSpec.describe #{resource_name}::BuildResource, type: :build_resource do/) }
  end
end
