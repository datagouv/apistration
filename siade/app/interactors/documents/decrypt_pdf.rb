class Documents::DecryptPDF < ApplicationInteractor
  def call
    encrypted_file = Tempfile.new(['encrypted', '.pdf'])
    encrypted_file.write(raw_pdf.force_encoding('UTF-8'))
    encrypted_file.flush
    decrypted_file = Tempfile.new('decrypted')
    qpdf_path = `which qpdf`
    raise('qpdf dependency not installed') if qpdf_path.empty?
    qpdf_path.chop! # remove trailing newline character
    system(qpdf_path, '--decrypt', '--no-warn', encrypted_file.path, decrypted_file.path)
    encrypted_file.close
    encrypted_file.unlink
    decrypted_file.rewind
    pdf = decrypted_file.read
    decrypted_file.close
    decrypted_file.unlink
    context.content = pdf
  end

  private

  def raw_pdf
    context.content
  end
end
