RSpec.describe ValidateResponseGenerator, type: :generator do
  let(:resource_name) { 'MODULE::ResourceName' }

  before { run_generator [resource_name] }

  describe 'ValidateParamsOrganizer class file' do
    subject { file('app/interactors/module/resource_name/validate_response.rb') }

    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/class #{resource_name}::ValidateResponse < ValidateResponse/) }
    it { is_expected.to have_method 'call' }
  end

  describe 'ValidateResponse spec file' do
    subject { file('spec/interactors/module/resource_name/validate_response_spec.rb') }

    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/RSpec.describe #{resource_name}::ValidateResponse, type: :validate_response do/) }
  end
end
