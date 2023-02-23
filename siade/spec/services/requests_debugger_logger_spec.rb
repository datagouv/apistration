RSpec.describe RequestsDebuggerLogger, type: :service do
  let(:instance) { described_class.instance }

  describe '.log' do
    subject { instance.log(params) }

    let(:params) do
      {
        what: 'ever'
      }
    end

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    it 'writes to the log a json object with params and datetime' do
      subject

      logger_file_content = Rails.root.join('log/requests_debugger.log').read

      expect(logger_file_content).to include(
        params.merge(
          datetime: DateTime.now
        ).to_json << "\n"
      )
    end
  end
end
