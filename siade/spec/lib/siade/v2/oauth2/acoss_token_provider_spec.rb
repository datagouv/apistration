RSpec.describe SIADE::V2::OAuth2::ACOSSTokenProvider, vcr: { cassette_name: 'acoss/oauth2', match_requests_on: %i[method uri body] } do
  subject { described_class.new }

  let(:access_token_from_vcr_acoss) { 'jJIHl8_MiMJ0fjF_-rGolr6mLRrG_WXy1RoIRGYHiGg' }

  its(:token) { is_expected.to eq access_token_from_vcr_acoss }
  its(:expires_in) { is_expected.to eq 3600 }
end
