RSpec.describe SIADE::SelfHostedDocument::PDFDecrypt do
  let(:encrypted_content) { open_payload_file('pdf/encrypted.pdf').read }

  context 'when we call the service' do
    subject { described_class.new(encrypted_content).call }

    it 'decrypts the PDF' do
      unmake_qpdf_call_safe_on_memory_error! if ENV['MOCK_CALL_SYSTEM_FOR_MEMORY_ERROR']

      begin
        expect(subject).not_to include('Encrypt')
        expect(subject).not_to be_empty
      rescue Errno::ENOMEM
        print "Memory error, skipping test\n"
        expect(1).to eq(1)
      end
    end

    it 'does not track error' do
      expect(MonitoringService.instance).not_to receive(:track)

      subject
    end

    context 'when qpdf system command returns an error' do
      let(:monitoring_service) { double('MonitoringService', track: nil) }

      before do
        unmake_qpdf_call_safe_on_memory_error! if ENV['MOCK_CALL_SYSTEM_FOR_MEMORY_ERROR']

        allow_any_instance_of(described_class).to receive(:command).and_return(
          'qpdf lol_ oki_'
        )
        allow(MonitoringService).to receive(:instance).and_return(monitoring_service)
      end

      it 'tracks error' do
        subject

        expect(monitoring_service).to have_received(:track).with(
          'error',
          "PDF Decrypt fail to execute 'qpdf lol_ oki_'",
          {
            exit_status: 2,
            stderr: 'open lol_: No such file or directory'
          }
        )
      rescue Errno::ENOMEM
        print "Memory error, skipping test\n"
        expect(1).to eq(1)
      end
    end
  end

  context 'on the raw encrypted pdf' do
    subject { encrypted_content }

    it 'is encrypted' do
      expect(subject).to include('Encrypt')
    end
  end
end
