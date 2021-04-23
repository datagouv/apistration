require 'open3'

class Documents::DecryptPDF < ApplicationInteractor
  def call
    raise('qpdf dependency not installed') if qpdf_path.empty?

    decrypt_file!

    clean_temporary_encrypted_file!

    context.content = raw_decrypted_file

    clean_temporary_decrypted_file!
  end

  private

  def qpdf_path
    @qpdf_path ||= `which qpdf`.chop
  end

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
    Open3.popen3(command) do |_stdin, _stdout, stderr, thread|
      unless thread.value.success?
        track_qpdf_error(
          thread.value.exitstatus,
          stderr,
        )
      end
    end
  end

  def command
    [
      qpdf_path,
      '--decrypt',
      encrypted_file.path,
      decrypted_file.path,
    ].join(' ')
  end

  def track_qpdf_error(exit_status, stderr)
    MonitoringService.instance.track(
      'error',
      "PDF Decrypt fail to execute '#{command}'",
      {
        exit_status: exit_status,
        stderr: stderr.read.chomp,
      }
    )
  end

  def raw_pdf
    context.content
  end
end
