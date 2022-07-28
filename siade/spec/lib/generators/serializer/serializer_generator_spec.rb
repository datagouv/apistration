RSpec.describe SerializerGenerator, type: :generator do
  let(:resource_name) { 'MODULE::ResourceName' }

  describe 'Serializer class file' do
    subject { file('app/serializers/api_entreprise/module/resource_name_serializer/v3.rb') }

    context 'with option: --document true' do
      before { run_generator [resource_name, '--document', 'true'] }

      it { is_expected.to exist }
      it { is_expected.to have_correct_syntax }
      it { is_expected.to contain(/class APIEntreprise::#{resource_name}Serializer::V3 < APIEntreprise::V3AndMore::DocumentSerializer/) }
    end

    context 'with option: --document false' do
      before { run_generator [resource_name, '--document', 'false'] }

      it { is_expected.to exist }
      it { is_expected.to have_correct_syntax }
      it { is_expected.to contain(/class APIEntreprise::#{resource_name}Serializer::V3 < APIEntreprise::V3AndMore::BaseSerializer/) }
    end
  end
end
