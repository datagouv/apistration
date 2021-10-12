require 'open3'

class SIADE::SelfHostedDocument::PDFDecrypt
  def initialize(raw_pdf)
    @raw_pdf = raw_pdf
  end

  def call
    raise('qpdf dependency not installed') if qpdf_path.empty?

    decrypt_file!

    clean_temporary_encrypted_file!

    pdf = raw_decrypted_file

    clean_temporary_decrypted_file!

    pdf
  end

  private

  def qpdf_path
    @qpdf_path ||= if ENV['CI']
                     '/usr/bin/qpdf'
                   else
                     `which qpdf`.chop
                   end
  end

  def encrypted_file
    @encrypted_file ||= begin
      encrypted_file = Tempfile.new(['encrypted', '.pdf'])
      encrypted_file.write(@raw_pdf.force_encoding('UTF-8'))
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
      stderr_string = stderr.read.chomp

      if !thread.value.success? && !provider_error?(stderr_string)
        track_qpdf_error(
          thread.value.exitstatus,
          stderr_string
        )
      end
    end
  end

  def command
    [
      qpdf_path,
      '--decrypt',
      encrypted_file.path,
      decrypted_file.path
    ].join(' ')
  end

  def track_qpdf_error(exit_status, stderr_string)
    MonitoringService.instance.track(
      'error',
      "PDF Decrypt fail to execute '#{command}'",
      {
        exit_status: exit_status,
        stderr: stderr_string
      }
    )
  end

  def provider_error?(stderr)
    [
      'unable to find trailer dictionary while recovering damaged file'
    ].any? do |error_message|
      stderr.include?(error_message)
    end
  end
end
