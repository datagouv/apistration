def open_payload_file(filename, read_option = nil)
  if read_option
    Rails.root.join('spec/fixtures/payloads/', filename).open(read_option)
  else
    Rails.root.join('spec/fixtures/payloads/', filename).open
  end
end

def read_payload_file(filename)
  Rails.root.join('spec/fixtures/payloads', filename).read
end

def encode64_payload_file(filename)
  Base64.strict_encode64(read_payload_file(filename))
end
