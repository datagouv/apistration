RSpec.describe ControllerGenerator, type: :generator do
  let(:resource_name) { 'MODULE::ResourceName' }

  describe 'Controller class file' do
    subject { file('app/controllers/api_entreprise/v3_and_more/module/resource_name_controller.rb') }

    shared_examples 'a valid Controller' do
      it { is_expected.to exist }
      it { is_expected.to have_correct_syntax }
      it { is_expected.to have_method 'show' }
    end

    context 'without options' do
      before { run_generator [resource_name] }

      it_behaves_like 'a valid Controller'
      it { is_expected.to contain(/class APIEntreprise::V3AndMore::#{resource_name}Controller < APIEntreprise::V3AndMore::BaseController/) }
    end

    context 'with option: --prochainement' do
      before { run_generator [resource_name, '--prochainement', 'true'] }

      it_behaves_like 'a valid Controller'
    end
  end
end
