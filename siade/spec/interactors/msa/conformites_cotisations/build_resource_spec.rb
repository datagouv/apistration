RSpec.describe MSA::ConformitesCotisations::BuildResource, type: :build_resource do
  subject { described_class.call(params: params, response: response) }

  let(:siret) { valid_siret(:msa) }
  let(:params) do
    {
      siret: siret
    }
  end
  let(:response) do
    instance_double('Net::HTTPOK', body: body)
  end

  context 'when it is up to date' do
    let(:body) { msa_cotisations_payload(siret, :up_to_date).to_json }

    it { is_expected.to be_a_success }

    it 'builds valid resource' do
      expect(subject.resource).to be_a(Resource)

      expect(subject.resource.status).to eq(:up_to_date)
    end
  end

  context 'when it is outdated' do
    let(:body) { msa_cotisations_payload(siret, :outdated).to_json }

    it { is_expected.to be_a_success }

    it 'builds valid resource' do
      expect(subject.resource).to be_a(Resource)

      expect(subject.resource.status).to eq(:outdated)
    end
  end

  context 'when it is under investigation' do
    let(:body) { msa_cotisations_payload(siret, :under_investigation).to_json }

    it { is_expected.to be_a_success }

    it 'builds valid resource' do
      expect(subject.resource).to be_a(Resource)

      expect(subject.resource.status).to eq(:under_investigation)
    end
  end
end
