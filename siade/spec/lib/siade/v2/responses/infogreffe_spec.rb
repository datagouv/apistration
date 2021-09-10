RSpec.describe SIADE::V2::Responses::Infogreffe, type: :provider_response do
  subject { SIADE::V2::Requests::Infogreffe.new(siren).perform.response }

  context 'when siren is not found', vcr: { cassette_name: 'infogreffe_extrait_rcs_with_not_found_siren' } do
    let(:siren) { not_found_siren(:extrait_rcs) }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'when siren is not avalaible', vcr: { cassette_name: 'infogreffe_extrait_rcs_with_not_available_siren' } do
    let(:siren) { '809902646' }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'when siren is valid', vcr: { cassette_name: 'infogreffe_extrait_rcs_with_valid_siren' } do
    let(:siren) { valid_siren(:extrait_rcs) }

    its(:http_code) { is_expected.to eq(200) }
  end

  context 'when ABONNE INTERDIT' do
    let(:url) { SIADE::V2::Requests::Infogreffe.new(siren: 'oki').send(:request_uri) }
    let(:siren) { valid_siren(:extrait_rcs) }
    let(:stub_response) do
      {
        status: 200,
        body: 'something that includes 005 -ABONNE INTERDIT- but not only'
      }
    end

    before do
      stub_request(:post, url).to_return(stub_response)
    end

    its(:http_code) { is_expected.to eq 500 }

    include_examples 'provider\'s response error'
  end
end
