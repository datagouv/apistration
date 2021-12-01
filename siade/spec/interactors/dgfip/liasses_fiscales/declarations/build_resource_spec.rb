RSpec.describe DGFIP::LiassesFiscales::Declarations::BuildResource, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
    subject(:builder) { described_class.call(response: response) }

    let(:response) do
      instance_double('Net::HTTPOK', body: body)
    end

    let(:body) { DGFIP::LiassesFiscales::Declarations::MakeRequest.call(cookie: cookie, params: params).response.body }
    let(:cookie) { DGFIP::Authenticate.call.cookie }
    let(:params) do
      {
        siren: valid_siren(:liasse_fiscale),
        user_id: valid_dgfip_user_id,
        year: 2017
      }
    end

    it { expect(builder.resource).to be_a(Resource) }

    it { expect(builder.resource.to_h).to match(a_hash_including(:id, :declarations)) }

    it { expect(builder.resource.declarations[0].keys).to eq(%i[date_declaration date_fin_exercice]) }
  end
end
