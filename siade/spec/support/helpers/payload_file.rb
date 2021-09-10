def open_payload_file(filename, read_option = nil)
  if read_option
    File.open(File.join(Rails.root, 'spec/support/payload_files/', filename), read_option)
  else
    File.open(File.join(Rails.root, 'spec/support/payload_files/', filename))
  end
end

def read_payload_file(filename)
  File.read(File.join(Rails.root, 'spec/support/payload_files', filename))
end

def encode64_payload_file(filename)
  Base64.strict_encode64(read_payload_file(filename))
end
