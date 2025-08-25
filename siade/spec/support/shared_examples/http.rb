RSpec.shared_examples 'unauthorized' do |action = :show, extra_get_params = {}|
  subject { response }

  before do
    params = { token: 'bad_token', siren: valid_siren, siret: valid_siret }.merge(api_entreprise_mandatory_params).merge(extra_get_params)
    get action, params:
  end

  its(:status) { is_expected.to eq(401) }

  it 'returns 401 with error message' do
    json = JSON.parse(response.body)

    expect(json).to have_json_error(code: '00101', detail: 'Votre token n\'est pas valide ou n\'est pas renseigné')
  end
end

RSpec.shared_examples 'forbidden' do |action = :show, extra_get_params = {}|
  subject { response }

  let(:token) { nope_jwt }
  let(:siret) { valid_siret }
  let(:siren) { valid_siren }

  before do
    params = { token:, siret:, siren: }.merge(api_entreprise_mandatory_params).merge(extra_get_params)
    get action, params:
  end

  its(:status) { is_expected.to eq(403) }
end

RSpec.shared_examples 'not_found' do |siret: nil, siren: nil, action: :show, **extra_get_params|
  subject { response }

  let(:token) { yes_jwt }
  let(:valid_siret) { siret || non_existent_siret }
  let(:valid_siren) { siren || non_existent_siren }

  before do
    get action, params: { token:, siret: valid_siret, siren: valid_siren }.merge(api_entreprise_mandatory_params).merge(extra_get_params)
  end

  its(:status) { is_expected.to eq(404) }

  it 'returns 404 with error message' do
    json = JSON.parse(response.body)

    expect(json).to have_json_error(detail: 'Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel')
  end
end

RSpec.shared_examples 'unprocessable_content' do |action = :show, kind = :siren, extra_get_params = {}|
  subject { response }

  let(:token) { yes_jwt }
  let(:siret) { invalid_siret }
  let(:siren) { invalid_siren }

  before do
    get action, params: { token:, siret:, siren: }.merge(api_entreprise_mandatory_params).merge(extra_get_params)
  end

  its(:status) { is_expected.to eq(422) }

  it 'returns 422 with error message' do
    json = JSON.parse(response.body)
    error = UnprocessableEntityError.new(kind)

    expect(json).to have_json_error(
      code: error.code,
      detail: error.detail
    )
  end
end

RSpec.shared_examples 'happy_pdf_endpoint_siren' do |arg_siren, pdf_suffix|
  subject { JSON.parse(response.body) }

  let(:token) { yes_jwt }
  let(:siren) { arg_siren }

  before do
    get :show, params: { token:, siren: }.merge(api_entreprise_mandatory_params)
  end

  it 'response has 200 status' do
    expect(response).to have_http_status(:ok)
  end

  its 'body has a url key' do
    expect(subject.keys).to include('url')
  end

  its 'body url is formatted with pdf_suffix' do
    expect(subject['url']).to match(/#{pdf_suffix}\.pdf/)
  end
end

RSpec.shared_examples 'happy_pdf_endpoint_siret' do |arg_siret, pdf_suffix|
  subject { JSON.parse(response.body) }

  let(:token) { yes_jwt }
  let(:siret) { arg_siret }

  before do
    get :show, params: { token:, siret: }.merge(api_entreprise_mandatory_params)
  end

  it 'response has 200 status' do
    expect(response).to have_http_status(:ok)
  end

  its 'body has a url key' do
    expect(subject.keys).to include('url')
  end

  its 'body url is formatted with pdf_suffix' do
    expect(subject['url']).to match(/#{pdf_suffix}\.pdf/)
  end
end

RSpec.shared_examples 'ask_for_mandatory_parameters' do |action = :show, extra_get_params = {}|
  subject do
    JSON.parse(response.body)
  end

  let(:token) { yes_jwt }
  let(:request_params) do
    {
      token:,
      siret: valid_siret(:octo),
      siren: valid_siren(:octo)
    }.merge(extra_get_params)
  end
  let(:object) { 'Test API Entreprise' }
  let(:context_param) { 'Tiers' }
  let(:recipient) { 'API Entreprise' }

  before do
    get action, params: request_params.merge(test_params)
  end

  context 'when object param is absent' do
    let(:test_params) { { context: context_param, recipient: } }

    it 'returns 422 with error message' do
      expect(response).to have_http_status :unprocessable_content
      expect(subject).to have_json_error(detail: 'Le paramètre object est obligatoire')
    end
  end

  context 'when context param is absent' do
    let(:test_params) { { object:, recipient: } }

    it 'returns 422 with error message' do
      expect(response).to have_http_status :unprocessable_content
      expect(subject).to have_json_error(detail: 'Le paramètre context est obligatoire')
    end
  end

  context 'when recipient param is absent' do
    let(:test_params) { { object:, context: context_param } }

    it 'returns 422 with error message' do
      expect(response).to have_http_status :unprocessable_content
      expect(subject).to have_json_error(detail: 'Le paramètre recipient est obligatoire')
    end
  end
end
