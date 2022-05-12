require 'hexapdf'

class Documents::DecryptPDF < ApplicationInteractor
  def call
    decrypt_file!

    clean_temporary_encrypted_file!

    context.content = raw_decrypted_file

    clean_temporary_decrypted_file!
  end

  private

  def encrypted_file
    @encrypted_file ||= begin
      encrypted_file = Tempfile.new(['encrypted', '.pdf'])
      encrypted_file.write(raw_pdf.force_encoding('UTF-8'))
      encrypted_file.flush
      encrypted_file
    end
  end

  def clean_temporary_encrypted_file!
    clean_temporary_file!(encrypted_file)
  end

  def clean_temporary_decrypted_file!
    clean_temporary_file!(decrypted_file)
  end

  def clean_temporary_file!(file)
    file.close
    file.unlink
  end

  def decrypted_file
    @decrypted_file ||= Tempfile.new('decrypted')
  end

  def raw_decrypted_file
    decrypted_file.rewind
    decrypted_file.read
  end

  def decrypt_file!
    doc = HexaPDF::Document.open(encrypted_file)
    doc.encrypt(name: nil)
    doc.write(decrypted_file)
  rescue HexaPDF::MalformedPDFError
    encrypted_file.rewind
    decrypted_file.write(encrypted_file.read)
  end

  def raw_pdf
    context.content
  end
end
