RSpec.describe SerializerGenerator, type: :generator do
  include_context 'with generator'

  let(:resource_name) { 'MODULE::ResourceName' }

  describe 'Serializer class file' do
    subject { file('app/serializers/module/resource_name/v3.rb') }

    context 'with option: --document true' do
      before { run_generator [resource_name, '--document', 'true'] }

      it { is_expected.to exist }
      it { is_expected.to have_correct_syntax }
      it { is_expected.to contain(/class #{resource_name}Serializer::V3 < JSONAPI::DocumentSerializer/) }
    end

    context 'with option: --document false' do
      before { run_generator [resource_name, '--document', 'false'] }

      it { is_expected.to exist }
      it { is_expected.to have_correct_syntax }
      it { is_expected.to contain(/class #{resource_name}Serializer::V3 < JSONAPI::BaseSerializer/) }
    end
  end
end
