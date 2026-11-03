def stub_credential(key, value)
  credentials = AdminApientreprise.credentials
  pass_unstubbed_credentials_through(credentials)
  allow(credentials).to receive(:[]).with(key).and_return(value)
  allow(credentials).to receive(:fetch).with(key, any_args).and_return(value)
end

def pass_unstubbed_credentials_through(credentials)
  return if @unstubbed_credentials_pass_through

  allow(credentials).to receive(:[]).and_call_original
  allow(credentials).to receive(:fetch).and_call_original
  @unstubbed_credentials_pass_through = true
end
