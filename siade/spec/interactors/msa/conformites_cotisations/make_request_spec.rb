RSpec.describe MSA::ConformitesCotisations::MakeRequest, type: :make_request do
  subject { described_class.call(params:) }

  let(:siret) { valid_siret(:msa) }
  let(:params) do
    {
      siret:
    }
  end

  before do
    mock_msa_cotisations(siret, status)
  end

  shared_examples 'MSA::ConformitesCotisations::MakeRequest call' do
    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'when siret is up to date' do
    it_behaves_like 'MSA::ConformitesCotisations::MakeRequest call' do
      let(:status) { :up_to_date }
    end
  end

  context 'when siret is outdated' do
    it_behaves_like 'MSA::ConformitesCotisations::MakeRequest call' do
      let(:status) { :outdated }
    end
  end

  context 'when siret is under investigation' do
    it_behaves_like 'MSA::ConformitesCotisations::MakeRequest call' do
      let(:status) { :under_investigation }
    end
  end

  context 'when siret does not exists or there is something wrong' do
    it_behaves_like 'MSA::ConformitesCotisations::MakeRequest call' do
      let(:status) { :unknown }
    end
  end
end
