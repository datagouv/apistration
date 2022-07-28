RSpec.describe ControllerGenerator, type: :generator do
  before { run_generator [resource_name] }

  let(:resource_name) { 'MODULE::ResourceName' }

  describe 'Controller class file' do
    subject { file('app/controllers/api_entreprise/v3_and_more/module/resource_name_controller.rb') }

    it { is_expected.to exist }
    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/class APIEntreprise::V3AndMore::#{resource_name}Controller < APIEntreprise::V3AndMore::BaseController/) }
    it { is_expected.to have_method 'show' }
  end
end
