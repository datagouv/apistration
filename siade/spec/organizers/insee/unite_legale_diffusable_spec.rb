RSpec.describe INSEE::UniteLegaleDiffusable, type: :retriever_organizer do
  subject { described_class.call(params:, operation_id: 'whatever') }

  let(:params) do
    {
      siren:
    }
  end

  context 'when it is staging' do
    let(:siren) { sirens_insee_v3[:active_GE] }

    let(:mocked_data) do
      {
        status: 200,
        payload: {
          what: :ever
        }
      }
    end

    before do
      allow(Rails).to receive(:env).and_return('staging'.inquiry)
      allow(MockService).to receive(:new).and_return(instance_double(MockService, mock: mocked_data))
    end

    it { is_expected.to be_a_success }
  end

  context 'with a valid siren, which is an active GE' do
    before do
      stub_insee_authenticate
      stub_insee_unite_legale_active_ge
    end

    let(:siren) { sirens_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end

  context 'with an entrepreneur individuel non diffusable' do
    before do
      stub_insee_authenticate
      stub_insee_unite_legale_non_diffusable
    end

    let(:siren) { non_diffusable_siren }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(NotFoundError) }
  end
end
