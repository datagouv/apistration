def open_payload_file(filename, read_option = nil)
  if read_option
    Rails.root.join('spec/support/payload_files/', filename).open(read_option)
  else
    Rails.root.join('spec/support/payload_files/', filename).open
  end
end

def read_payload_file(filename)
  Rails.root.join('spec/support/payload_files', filename).read
end

def encode64_payload_file(filename)
  Base64.strict_encode64(read_payload_file(filename))
end
