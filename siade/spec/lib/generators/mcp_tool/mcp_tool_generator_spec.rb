RSpec.describe McpToolGenerator, type: :generator do
  let(:resource_name) { 'MODULE::ResourceName' }

  before do
    FileUtils.mkdir_p('tmp/config')
    FileUtils.cp(Rails.root.join('config/authorizations.yml'), 'tmp/config/authorizations.yml')

    run_generator [resource_name]
  end

  describe 'tool file' do
    subject { file('app/tools/module/resource_name_tool.rb') }

    it { is_expected.to have_correct_syntax }
  end

  describe 'tool spec file' do
    subject { file('spec/tools/module/resource_name_tool_spec.rb') }

    it { is_expected.to have_correct_syntax }
  end
end
