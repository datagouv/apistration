RSpec.describe MakeRequestGenerator, type: :generator do
  let(:request_name) { 'MODULE::ResourceName' }

  describe 'MakeRequest class file' do
    subject { file('app/interactors/module/resource_name/make_request.rb') }

    shared_examples 'a valid MakeRequest' do
      it { is_expected.to exist }
      it { is_expected.to have_method 'request_uri' }
      it { is_expected.to have_method 'request_params' }
      it { is_expected.to have_correct_syntax }
    end

    context 'with option: --verb GET request' do
      before { run_generator [request_name, '--verb', 'GET'] }

      it_behaves_like 'a valid MakeRequest'
      it { is_expected.to contain(/class #{request_name}::MakeRequest < MakeRequest::Get/) }
    end

    context 'with option: --verb POST request' do
      before { run_generator [request_name, '--verb', 'POST'] }

      it_behaves_like 'a valid MakeRequest'
      it { is_expected.to contain(/class #{request_name}::MakeRequest < MakeRequest::Post/) }
    end

    context 'without any option' do
      before { run_generator [request_name] }

      it_behaves_like 'a valid MakeRequest'
      it { is_expected.to contain(/class #{request_name}::MakeRequest < MakeRequest::Get/) }
    end
  end

  describe 'MakeRequest spec file' do
    subject { file('spec/interactors/module/resource_name/make_request_spec.rb') }

    before { run_generator [request_name] }

    it { is_expected.to exist }
    it { is_expected.to have_correct_syntax }
    it { is_expected.to contain(/RSpec.describe #{request_name}::MakeRequest, type: :make_request do/) }
  end
end
