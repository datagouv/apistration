RSpec.describe INSEE::Etablissement::MakeRequest, type: :make_request do
  subject(:make_request) { described_class.call(params:, token:) }

  let(:params) do
    {
      siret:
    }
  end

  let(:token) { 'valid insee token' }

  context 'with a valid siret' do
    before { stub_insee_etablissement_active_ge }

    let(:siret) { sirets_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a non-existent siret' do
    before { stub_insee_etablissement_non_existent }

    let(:siret) { non_existent_siret }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end

  context 'with an entrepreneur individuel non diffusable ceased' do
    before { stub_insee_etablissement_non_diffusable_ceased }

    let(:siret) { confidential_siret(:non_diffusable_ceased) }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPForbidden) }
  end

  context 'with an entrepreneur individuel non diffusable' do
    before { stub_insee_etablissement_non_diffusable }

    let(:siret) { non_diffusable_siret }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a gendarmerie' do
    before { stub_insee_etablissement_gendarmerie_limousin }

    let(:siret) { confidential_siret(:gendarmerie_limousin) }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPForbidden) }
  end

  context 'with a siret which redirects to another location' do
    before { stub_insee_etablissement_redirected }

    let(:siret) { '53222169400013' }
    let(:redirected_siret) { '77887067500015' }

    it { is_expected.to be_a_success }

    it 'performs a get request on the new location' do
      make_request

      expect(WebMock).to have_requested(:get, /#{Siade.credentials[:insee_sirene_url]}.*#{redirected_siret}/)
    end

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
