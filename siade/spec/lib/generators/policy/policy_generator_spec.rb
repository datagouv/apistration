RSpec.describe PolicyGenerator, type: :generator do
  before { run_generator [resource_name] }

  let(:resource_name) { 'MODULE::ResourceName' }

  describe 'Policy class file' do
    subject { file('app/policies/resource_name_policy.rb') }

    it { is_expected.to exist }
    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/class #{resource_name}Policy < APIPolicy/) }
    it { is_expected.to have_method 'jwt_scope_tag' }
  end

  describe 'Policy spec file' do
    subject { file('spec/policies/resource_name_policy_spec.rb') }

    it { is_expected.to exist }
    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/RSpec.describe #{resource_name}Policy do/) }
  end
end
