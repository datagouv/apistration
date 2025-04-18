RSpec.describe DSNJ::ServiceNational::MakeRequest, type: :make_request do
  subject { described_class.call(params:) }

  let(:params) do
    {
      prenoms: %w[Jean Paul],
      nom_naissance: 'DUPONT',
      jour_date_naissance: '01',
      mois_date_naissance: '10',
      annee_date_naissance: '2000',
      sexe_etat_civil: 'M',
      code_cog_insee_commune_naissance: '90000',
      code_cog_insee_pays_naissance: '99100'
    }
  end

  let(:request_params) do
    {
      given_name: 'Jean',
      family_name: 'DUPONT',
      birthdate: '2000-10-01',
      gender: 'male',
      birthplace: '90000',
      birthcountry: '99100'
    }
  end

  let(:body) do
    { identites_pivot: [request_params] }.to_json
  end

  let(:headers) do
    {
      'Authorization' => "Bearer #{Siade.credentials[:dsnj_service_national_token]}",
      'Content-Type' => 'application/json; charset=utf-8'
    }
  end

  let!(:stubbed_request) do
    stub_request(:post, Siade.credentials[:dsnj_service_national_url]).with(
      body:, headers:
    )
  end

  it { is_expected.to be_a_success }

  it 'calls url with valid body and headers' do
    subject

    expect(stubbed_request).to have_been_requested
  end
end
