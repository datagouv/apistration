module MockCallSystemForCi
  def make_qpdf_call_safe_on_memory_error!
    allow_any_instance_of(SIADE::SelfHostedDocument::PDFDecrypt).to receive(:decrypt_file!).and_wrap_original do |method|
      method.call
    rescue Errno::ENOMEM
      print "Memory error: fail to decrypt file, copy encrypted file through ruby instead\n"
      File.write(
        method.receiver.send(:decrypted_file).path,
        File.read(method.receiver.send(:encrypted_file).path)
      )
    end
  end

  def unmake_qpdf_call_safe_on_memory_error!
    allow_any_instance_of(SIADE::SelfHostedDocument::PDFDecrypt).to receive(:decrypt_file!).and_call_original
  end
end
