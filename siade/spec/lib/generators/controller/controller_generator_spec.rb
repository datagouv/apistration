RSpec.describe ControllerGenerator, type: :generator do
  include_context 'with generator'

  before { run_generator [resource_name] }

  let(:resource_name) { 'MODULE::ResourceName' }

  describe 'Controller class file' do
    subject { file('app/controllers/api/v3_and_more/module/resource_name_controller.rb') }

    it { is_expected.to exist }
    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/class API::V3AndMore::#{resource_name}Controller < API::V3AndMore::BaseController/) }
    it { is_expected.to have_method 'show' }
  end

  describe 'Controller spec file' do
    subject { file('spec/controllers/api/v3_and_more/module/resource_name_controller_spec.rb') }

    it { is_expected.to exist }
    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/RSpec.describe API::V3AndMore::#{resource_name}Controller, type: :controller do/) }
  end
end
