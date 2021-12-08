def stub_credential(key, value)
  allow(Siade.credentials).to receive(:[]).and_call_original
  allow(Siade.credentials).to receive(:[]).with(key).and_return(value)
end
