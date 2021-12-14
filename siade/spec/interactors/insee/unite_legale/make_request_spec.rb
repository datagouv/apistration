RSpec.describe INSEE::UniteLegale::MakeRequest, type: :make_request do
  subject(:make_request) { described_class.call(params:, token:) }

  let(:params) do
    {
      siren:
    }
  end

  let(:token) { 'valid insee token' }

  context 'with a valid siren', vcr: { cassette_name: 'insee/siren/active_GE' } do
    let(:siren) { sirens_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a non-existent siren', vcr: { cassette_name: 'insee/siren/non_existent' } do
    let(:siren) { non_existent_siren }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end

  context 'with an entrepreneur individuel non diffusable ceased', vcr: { cassette_name: 'insee/siren/non_diffusable_ceased' } do
    let(:siren) { confidential_siren(:non_diffusable_ceased) }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPForbidden) }
  end

  context 'with an entrepreneur individuel non diffusable', vcr: { cassette_name: 'insee/siren/non_diffusable' } do
    let(:siren) { non_diffusable_siren }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a gendarmerie', vcr: { cassette_name: 'insee/siren/gendarmerie_limousin' } do
    let(:siren) { confidential_siren(:gendarmerie_limousin) }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPForbidden) }
  end

  context 'with a siren which redirects to another location', vcr: { cassette_name: 'insee/siren/redirected' } do
    let(:siren) { '532221694' }
    let(:redirected_siren) { '778870675' }

    it { is_expected.to be_a_success }

    it 'performs a get request on the new location' do
      make_request

      expect(WebMock).to have_requested(:get, /#{Siade.credentials[:insee_v3_domain]}.*#{redirected_siren}/)
    end

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
