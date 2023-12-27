RSpec.describe ValidateParamsGenerator, type: :generator do
  let(:resource_name) { 'MODULE::ResourceName' }

  before { run_generator [resource_name] }

  describe 'ValidateParam class file' do
    subject { file('app/organizers/module/resource_name/validate_params.rb') }

    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/class #{resource_name}::ValidateParams < ValidateParamsOrganizer/) }
    it { is_expected.to contain(/organize ValidateSiren/) }
  end

  describe 'ValidateParam spec file' do
    subject { file('spec/organizers/module/resource_name/validate_params_spec.rb') }

    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/RSpec.describe #{resource_name}::ValidateParams, type: :validate_params do/) }
  end
end
