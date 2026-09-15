RSpec.describe INSEE::UniteLegale::MakeRequest, type: :make_request do
  subject(:make_request) { described_class.call(params:, token:) }

  let(:params) do
    {
      siren:
    }
  end

  let(:token) { 'valid insee token' }

  context 'with a valid siren' do
    before { stub_insee_unite_legale_active_ge }

    let(:siren) { sirens_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a non-existent siren' do
    before { stub_insee_unite_legale_non_existent }

    let(:siren) { non_existent_siren }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end

  context 'with an entrepreneur individuel non diffusable ceased' do
    before { stub_insee_unite_legale_non_diffusable_ceased }

    let(:siren) { confidential_siren(:non_diffusable_ceased) }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPForbidden) }
  end

  context 'with an entrepreneur individuel non diffusable' do
    before { stub_insee_unite_legale_non_diffusable }

    let(:siren) { non_diffusable_siren }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a gendarmerie' do
    before { stub_insee_unite_legale_gendarmerie_limousin }

    let(:siren) { confidential_siren(:gendarmerie_limousin) }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPForbidden) }
  end

  context 'with a siren which redirects to another location' do
    before { stub_insee_unite_legale_redirected }

    let(:siren) { '532221694' }
    let(:redirected_siren) { '778870675' }

    it { is_expected.to be_a_success }

    it 'performs a get request on the new location' do
      make_request

      expect(WebMock).to have_requested(:get, /#{Siade.credentials[:insee_sirene_url]}.*#{redirected_siren}/)
    end

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
