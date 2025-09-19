RSpec.describe McpToolGenerator, type: :generator do
  let(:resource_name) { 'MODULE::ResourceName' }

  before { run_generator [resource_name] }

  describe 'tool file' do
    subject { file('app/tools/module/resource_name_tool.rb') }

    it { is_expected.to have_correct_syntax }
  end

  describe 'tool spec file' do
    subject { file('spec/tools/module/resource_name_tool_spec.rb') }

    it { is_expected.to have_correct_syntax }
  end
end
