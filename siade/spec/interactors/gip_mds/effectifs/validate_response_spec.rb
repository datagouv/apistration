RSpec.describe GIPMDS::Effectifs::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'GIP-MDS') }

  let(:response) do
    instance_double(Net::HTTPOK, code:, body:)
  end

  context 'with a status OK' do
    let(:code) { '200' }

    context 'when there at least one effectif with a valid count' do
      let(:body) do
        [
          {
            source: 'RA',
            effectifs: '16.64'
          },
          {
            source: 'RG',
            effectifs: 'NC'
          }
        ].shuffle.to_json
      end

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when all effectifs have no valid count' do
      let(:body) do
        [
          {
            source: 'RA',
            effectifs: 'NC'
          },
          {
            source: 'RG',
            effectifs: 'NC'
          }
        ].to_json
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'when array does not contains at least RA and RG source' do
      let(:body) do
        [
          {
            source: 'RA',
            effectifs: 'NC'
          }
        ].to_json
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'with an invalid body' do
      let(:body) { 'invalid' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'with a code key and KO_TECHNIQUE' do
      let(:body) do
        {
          code: 'KO_TECHNIQUE'
        }.to_json
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(GIPMDSError)) }
    end
  end

  context 'with a 204 status' do
    let(:code) { '204' }
    let(:body) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with a 401 or 403 status' do
    let(:code) { %w[401 403].sample }
    let(:body) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(GIPMDSError)) }
  end

  context 'with a 429 status' do
    let(:code) { '429' }
    let(:body) do
      {
        code: '900803',
        message: 'Message throttled out',
        description: 'You have exceeded your quota',
        nextAccessTime: '2023-Oct-12 20:43:00+0000 UTC'
      }.to_query
    end

    before do
      Timecop.freeze(Time.zone.local(2023, 10, 12, 20, 40))
    end

    after do
      Timecop.return
    end

    it { is_expected.to be_a_failure }
    its(:errors) { is_expected.to include(instance_of(GIPMDSError)) }

    it 'sets a retry_in on the error' do
      expect(subject.errors.first.meta[:retry_in]).to eq(3.minutes.to_i + 2.hours.to_i)
    end

    it 'tracks the quota error via MonitoringService' do
      allow(MonitoringService.instance).to receive(:track_with_added_context)

      subject

      expect(MonitoringService.instance).to have_received(:track_with_added_context).with(
        'warning',
        '[GIP-MDS] Quota exceeded',
        { next_access_time: '2023-Oct-12 20:43:00+0000 UTC' }
      )
    end
  end

  context 'with a 500 status' do
    let(:code) { '500' }
    let(:body) { '' }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
  end

  context 'with unknown provider code' do
    let(:code) { '66' }
    let(:body) { 'execute order' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(an_instance_of(ProviderUnknownError)) }
  end
end
