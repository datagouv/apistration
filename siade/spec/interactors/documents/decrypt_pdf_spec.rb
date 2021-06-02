RSpec.describe Documents::DecryptPDF do
  subject { described_class.call(decrypt_params) }

  let(:encrypted_content) { open_payload_file('pdf/encrypted.pdf').read }
  let(:decrypt_params) do
    { content: encrypted_content }
  end

  context 'when we call the interactor' do
    it "is a success" do
      if ENV['MOCK_CALL_SYSTEM_FOR_MEMORY_ERROR']
        unmake_qpdf_call_safe_on_memory_error!
      end

      begin
        expect(subject).to be_a_success
      rescue Errno::ENOMEM
        print "Memory error, skipping test\n"
        expect(1).to eq(1)
      end
    end

    it 'decrypts the PDF' do
      if ENV['MOCK_CALL_SYSTEM_FOR_MEMORY_ERROR']
        unmake_qpdf_call_safe_on_memory_error!
      end

      begin
        expect(subject.content).not_to include('Encrypt')
        expect(subject.content).not_to be_empty
      rescue Errno::ENOMEM
        print "Memory error, skipping test\n"
        expect(1).to eq(1)
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
      if ENV['MOCK_CALL_SYSTEM_FOR_MEMORY_ERROR']
        unmake_qpdf_call_safe_on_memory_error!
      end

      allow_any_instance_of(described_class).to receive(:command).and_return(
        'qpdf lol oki',
      )
      allow(MonitoringService).to receive(:instance).and_return(monitoring_service)
    end

    it 'tracks error' do
      begin
        subject

        expect(monitoring_service).to have_received(:track).with(
          'error',
          "PDF Decrypt fail to execute 'qpdf lol oki'",
          {
            exit_status: 2,
            stderr: 'open lol: No such file or directory',
          },
        )
      rescue Errno::ENOMEM
        print "Memory error, skipping test\n"
        expect(1).to eq(1)
      end
    end
  end
end
