RSpec.describe RequestSpecGenerator, type: :generator do
  subject { file('spec/requests/api_entreprise/v3_and_more/module/resource_name/v3_spec.rb') }

  let(:resource_name) { 'MODULE::ResourceName' }

  before { run_generator [resource_name] }

  it { is_expected.to exist }
  it { is_expected.to have_correct_syntax }
  it { is_expected.to contain(%r{/v3/module/resource_names}) }
end
