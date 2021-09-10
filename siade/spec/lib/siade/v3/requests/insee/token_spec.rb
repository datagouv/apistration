RSpec.describe SIADE::V3::Requests::INSEE::Token, type: :provider_request, vcr: { cassette_name: 'renew_insee_token' } do
  subject { described_class.new }

  # it doesn't catch any error, none occured yet
  its(:token) { is_expected.to eq '34ca8c63-891b-3479-86be-2c40f66497a2' }
  its(:expires_in) { is_expected.to eq 598_077 }
  its(:expiration_date) { is_expected.not_to be_nil }
end
