RSpec.describe RequestSpecGenerator, type: :generator do
  subject { file('spec/requests/api_entreprise/v3_and_more/module/resource_name/v3_spec.rb') }

  let(:resource_name) { 'MODULE::ResourceName' }

  shared_examples 'a valid request spec file' do
    it { is_expected.to exist }
    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(%r{/v3/module/resource_names}) }
  end

  context 'without options' do
    before { run_generator [resource_name] }

    it_behaves_like 'a valid request spec file'
  end

  context 'with option --prochainement' do
    before { run_generator [resource_name, '--prochainement', 'true'] }

    it_behaves_like 'a valid request spec file'
  end
end
