RSpec.describe INSEE::SiegeUniteLegale::MakeRequest, type: :make_request do
  subject(:make_request) { described_class.call(params:, token:) }

  let(:params) do
    {
      siren:
    }
  end

  let(:token) { INSEE::Authenticate.call.token }

  context 'with a valid siren' do
    before do
      stub_insee_authenticate
      stub_insee_siege_active_ge
    end

    let(:siren) { sirens_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a non-existent siren' do
    before do
      stub_insee_authenticate
      stub_insee_siege_non_existent
    end

    let(:siren) { non_existent_siren }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end

  context 'with an entrepreneur individuel non diffusable ceased' do
    before do
      stub_insee_authenticate
      stub_insee_siege_non_diffusable_ceased
    end

    let(:siren) { confidential_siren(:non_diffusable_ceased) }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end

  context 'with an entrepreneur individuel non diffusable' do
    before do
      stub_insee_authenticate
      stub_insee_siege_non_diffusable
    end

    let(:siren) { non_diffusable_siren }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'with a gendarmerie' do
    before do
      stub_insee_authenticate
      stub_insee_siege_gendarmerie_limousin
    end

    let(:siren) { confidential_siren(:gendarmerie_limousin) }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end

  context 'with a siren which redirects to another location' do
    before do
      stub_insee_authenticate
      stub_insee_siege_redirected
    end

    let(:siren) { '532221694' }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end
end
