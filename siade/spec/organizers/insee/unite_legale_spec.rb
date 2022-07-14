RSpec.describe INSEE::UniteLegale, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:
    }
  end

  context 'with a valid siren, which is an active GE', vcr: { cassette_name: 'insee/siren/active_GE_with_token' } do
    let(:siren) { sirens_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end

  context 'with an entrepreneur individuel non diffusable', vcr: { cassette_name: 'insee/siren/non_diffusable_with_token' } do
    let(:siren) { non_diffusable_siren }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end
end
