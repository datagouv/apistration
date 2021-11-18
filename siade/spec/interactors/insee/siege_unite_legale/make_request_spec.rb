RSpec.describe INSEE::SiegeUniteLegale::MakeRequest, type: :make_request do
  subject(:make_request) { described_class.call(params: params, token: token) }

  let(:params) do
    {
      siren: siren
    }
  end

  let(:token) { INSEE::Authenticate.call.token }

  context 'with a valid siren', vcr: { cassette_name: 'insee/siege/active_GE_with_token' } do
    let(:siren) { sirens_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a non-existent siren', vcr: { cassette_name: 'insee/siege/non_existent_with_token' } do
    let(:siren) { non_existent_siren }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end

  context 'with an entrepreneur individuel non diffusable ceased', vcr: { cassette_name: 'insee/siege/non_diffusable_ceased_with_token' } do
    let(:siren) { confidential_siren(:non_diffusable_ceased) }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end

  context 'with an entrepreneur individuel non diffusable', vcr: { cassette_name: 'insee/siege/non_diffusable_with_token' } do
    let(:siren) { non_diffusable_siren }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a gendarmerie', vcr: { cassette_name: 'insee/siege/gendarmerie_limousin_with_token' } do
    let(:siren) { confidential_siren(:gendarmerie_limousin) }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end

  context 'with a siren which redirects to another location', vcr: { cassette_name: 'insee/siege/redirected_with_token' } do
    let(:siren) { '532221694' }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end
end
