RSpec.describe BuildResourceGenerator, type: :generator do
  let(:resource_name) { 'MODULE::ResourceName' }

  describe 'BuildResource class file' do
    subject { file('app/interactors/module/resource_name/build_resource.rb') }

    shared_examples 'a valid BuildResource' do
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

    context 'with option: --is_collection true' do
      subject { file('app/interactors/module/resource_name/build_resource_collection.rb') }

      before { run_generator [resource_name, '--is_collection', 'true'] }

      it_behaves_like 'a valid BuildResource'
      it { is_expected.to contain(/class #{resource_name}::BuildResourceCollection < BuildResourceCollection/) }
      it { is_expected.to have_method 'items' }
      it { is_expected.to have_method 'items_meta' }
      it { is_expected.to have_method 'resource_attributes' }
    end
  end

  describe 'BuildResource spec file' do
    context 'with option: --is_collection false' do
      subject { file('spec/interactors/module/resource_name/build_resource_spec.rb') }

      before { run_generator [resource_name] }

      it { is_expected.to have_correct_syntax }
      it { is_expected.to contain(/RSpec.describe #{resource_name}::BuildResource, type: :build_resource do/) }
    end

    context 'with option: --is_collection true' do
      subject { file('spec/interactors/module/resource_name/build_resource_collection_spec.rb') }

      let(:header) { Regexp.new("RSpec.describe #{resource_name}::BuildResourceCollection, type: :build_resource do") }

      before { run_generator [resource_name, '--is_collection', 'true'] }

      it { is_expected.to have_correct_syntax }

      it { is_expected.to contain(header) }
    end
  end
end
