RSpec.describe INSEE::Etablissement, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:
    }
  end

  context 'with a valid siret, which is an active GE' do
    before do
      stub_insee_authenticate
      stub_insee_etablissement_active_ge
    end

    let(:siret) { sirets_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end

  context 'with an entrepreneur individuel non diffusable' do
    before do
      stub_insee_authenticate
      stub_insee_etablissement_non_diffusable
    end

    let(:siret) { non_diffusable_siret }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end
end
