RSpec.describe Sentry, '#traces_sampler' do
  subject(:sample_rate) { described_class.configuration.traces_sampler.call(sampling_context) }

  context 'when the kubelet probes the app' do
    let(:sampling_context) { { env: { 'PATH_INFO' => '/healthz/database' }, parent_sampled: true } }

    it { is_expected.to eq(0.0) }
  end

  context 'when a request comes in without an incoming trace' do
    let(:sampling_context) { { env: { 'PATH_INFO' => '/healthzz' }, parent_sampled: nil } }

    it { is_expected.to eq(1.0) }
  end

  context 'when an incoming trace was dropped upstream' do
    let(:sampling_context) { { env: { 'PATH_INFO' => '/healthzz' }, parent_sampled: false } }

    it { is_expected.to be(false) }
  end

  context 'when a job runs outside any request' do
    let(:sampling_context) { { parent_sampled: nil } }

    it { is_expected.to eq(1.0) }
  end
end
