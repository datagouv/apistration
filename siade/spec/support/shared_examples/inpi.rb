RSpec.shared_examples 'inpi authentication failure' do
  # rubocop:disable RSpec/AnyInstance
  before do
    allow_any_instance_of(SIADE::V2::Requests::INPI::Authenticate)
      .to receive(:cookie).and_return(nil)

    get :show, params: { siren:, token: yes_jwt }.merge(api_entreprise_mandatory_params)
  end
  # rubocop:enable RSpec/AnyInstance

  let(:siren) { valid_siren(:inpi_pdf) }

  it 'returns HTTP code 502' do
    expect(response).to have_http_status(:bad_gateway)
  end

  it 'returns an error message' do
    expect(response_json).to have_json_error(detail: "L'authentification auprès du fournisseur de données 'INPI' a échoué")
  end
end
