RSpec.describe INSEE::Etablissement::MakeRequest, type: :make_request do
  subject(:make_request) { described_class.call(params:, token:) }

  let(:params) do
    {
      siret:
    }
  end

  let(:token) { 'valid insee token' }

  context 'with a valid siret', vcr: { cassette_name: 'insee/siret/active_GE' } do
    let(:siret) { sirets_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a non-existent siret', vcr: { cassette_name: 'insee/siret/non_existent' } do
    let(:siret) { non_existent_siret }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end

  context 'with an entrepreneur individuel non diffusable ceased', vcr: { cassette_name: 'insee/siret/non_diffusable_ceased' } do
    let(:siret) { confidential_siret(:non_diffusable_ceased) }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPForbidden) }
  end

  context 'with an entrepreneur individuel non diffusable', vcr: { cassette_name: 'insee/siret/non_diffusable' } do
    let(:siret) { non_diffusable_siret }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a gendarmerie', vcr: { cassette_name: 'insee/siret/gendarmerie_limousin' } do
    let(:siret) { confidential_siret(:gendarmerie_limousin) }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPForbidden) }
  end

  context 'with a siret which redirects to another location', vcr: { cassette_name: 'insee/siret/redirected' } do
    let(:siret) { '53222169400013' }
    let(:redirected_siret) { '77887067500015' }

    it { is_expected.to be_a_success }

    it 'performs a get request on the new location' do
      make_request

      expect(WebMock).to have_requested(:get, /#{Siade.credentials[:insee_v3_domain]}.*#{redirected_siret}/)
    end

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
