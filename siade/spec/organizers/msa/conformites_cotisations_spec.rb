RSpec.describe MSA::ConformitesCotisations, type: :retriever_organizer do
  subject { described_class.call(params: params) }

  let(:siret) { valid_siret(:msa) }
  let(:params) do
    {
      siret: siret
    }
  end

  before do
    mock_msa_cotisations(siret, status)
  end

  shared_examples 'MSA::ConformitesCotisations success' do
    it { is_expected.to be_success }

    it 'sets the resource id' do
      id = subject.resource.id

      expect(id).to eq(siret)
    end
  end

  context 'when siret is up to date' do
    it_behaves_like 'MSA::ConformitesCotisations success' do
      let(:status) { :up_to_date }
    end
  end

  context 'when siret is outdated' do
    it_behaves_like 'MSA::ConformitesCotisations success' do
      let(:status) { :outdated }
    end
  end

  context 'when siret is under investigation' do
    it_behaves_like 'MSA::ConformitesCotisations success' do
      let(:status) { :under_investigation }
    end
  end

  context 'when siret does not exists or there is something wrong' do
    let(:status) { :unknown }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to have_error('Le siret indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
  end
end
