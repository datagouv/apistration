# rubocop:disable Metrics/AbcSize
def stub_credential(key, value)
  allow(AdminApientreprise.credentials).to receive(:[]).and_call_original
  allow(AdminApientreprise.credentials).to receive(:[]).with(key).and_return(value)
  allow(AdminApientreprise.credentials).to receive(:fetch).and_call_original
  allow(AdminApientreprise.credentials).to receive(:fetch).with(key).and_return(value)
  allow(AdminApientreprise.credentials).to receive(:fetch).with(key, anything).and_return(value)
end
# rubocop:enable Metrics/AbcSize
