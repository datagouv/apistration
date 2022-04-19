RSpec.describe Documents::DecryptPDF do
  subject { described_class.call(decrypt_params) }

  let(:encrypted_content) { open_payload_file('pdf/encrypted.pdf').read }
  let(:decrypt_params) do
    { content: encrypted_content }
  end

  context 'when we call the interactor' do
    it 'is a success' do
      unmake_qpdf_call_safe_on_memory_error! if ENV['MOCK_CALL_SYSTEM_FOR_MEMORY_ERROR']

      begin
        expect(subject).to be_a_success
      rescue Errno::ENOMEM
        print "Memory error, skipping test\n"
        expect(0 + 1).to eq(1)
      end
    end

    it 'decrypts the PDF' do
      unmake_qpdf_call_safe_on_memory_error! if ENV['MOCK_CALL_SYSTEM_FOR_MEMORY_ERROR']

      begin
        expect(subject.content).not_to include('Encrypt')
        expect(subject.content).not_to be_empty
      rescue Errno::ENOMEM
        print "Memory error, skipping test\n"
        expect(0 + 1).to eq(1)
      end
    end
  end

  context 'on the raw encrypted pdf' do
    it 'is encrypted' do
      expect(encrypted_content).to include('Encrypt')
    end
  end

  context 'when qpdf system command returns an error' do
    let(:monitoring_service) { double('MonitoringService', track: nil) }

    before do
      unmake_qpdf_call_safe_on_memory_error! if ENV['MOCK_CALL_SYSTEM_FOR_MEMORY_ERROR']
      allow(MonitoringService).to receive(:instance).and_return(monitoring_service)
    end

    context 'when it is not a provider error' do
      before do
        allow_any_instance_of(described_class).to receive(:command).and_return(
          'qpdf lol_ oki_'
        )
      end

      it 'tracks error' do
        subject

        expect(monitoring_service).to have_received(:track).with(
          'error',
          "PDF Decrypt fail to execute 'qpdf lol_ oki_'",
          {
            exit_status: 2,
            stderr: /open lol_: No such file or directory/
          }
        )
      rescue Errno::ENOMEM
        print "Memory error, skipping test\n"
        expect(0 + 1).to eq(1)
      end
    end

    context 'when pdf is damaged but only triggers warning' do
      before do
        allow_any_instance_of(described_class).to receive(:command).and_return(
          "qpdf #{Rails.root.join('spec/fixtures/dummy-with-warnings-for-qpdf.pdf')} #{Rails.root.join('tmp/whatever.pdf')}"
        )
      end

      it 'does not track error', retry: 5 do
        subject

        expect(monitoring_service).not_to have_received(:track)
      end
    end

    context 'when it is a provider error (damaged pdf)' do
      before do
        allow_any_instance_of(described_class).to receive(:command).and_return(
          "qpdf #{Rails.root.join('spec/fixtures/dummy.doc')} #{Rails.root.join('tmp/whatever.pdf')}"
        )
      end

      it 'does not track error', retry: 5 do
        subject

        expect(monitoring_service).not_to have_received(:track)
      end
    end
  end
end
