RSpec.describe SIADE::V2::Responses::CertificatsCNETP, type: :provider_response do

  subject { SIADE::V2::Requests::CertificatsCNETP.new(siren).perform.response }

  context 'when siren is not found', vcr: { cassette_name: 'cnetp_with_not_found_siren' } do
    let(:siren) { non_existent_siren }
    its(:class) { is_expected.to eq(SIADE::V2::Responses::ResourceNotFound) }
  end
end
