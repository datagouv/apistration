RSpec.describe ApplicationJob do
  let(:failing_job) do
    stub_const('FailingJob', Class.new(described_class) do
      cattr_accessor :attempts, default: 0

      def perform
        self.class.attempts += 1

        raise 'provider unavailable'
      end
    end)
  end

  it 'retries a failing job 5 times in total before letting the error reach Sentry' do
    expect { perform_with_retries(failing_job) }.to raise_error(RuntimeError, 'provider unavailable')

    expect(failing_job.attempts).to eq(5)
  end

  it 'waits before retrying instead of retrying at once' do
    failing_job.perform_now

    expect(failing_job).to have_been_enqueued.at(a_value_within(5.seconds).of(3.seconds.from_now))
  end

  describe 'a job declared without retry' do
    before { failing_job.without_retry }

    it 'fails on the first error, which reaches Sentry' do
      expect { perform_with_retries(failing_job) }.to raise_error(RuntimeError, 'provider unavailable')

      expect(failing_job.attempts).to eq(1)
    end
  end
end
