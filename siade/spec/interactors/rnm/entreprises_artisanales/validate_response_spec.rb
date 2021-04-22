require 'rails_helper'

RSpec.describe RNM::EntreprisesArtisanales::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response: response) }

    let(:params) do
      {
        siren: valid_siren(:rnm_cma),
      }
    end

    let(:response) do
      instance_double('Net::HTTPOK', code: code, body: body)
    end

    context 'with valid response', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
      let(:code) { '200' }
      let(:body) do
        RNM::EntreprisesArtisanales::MakeRequest.call(params: params).response.body
      end

      it { is_expected.to be_a_success }

      its(:status) { is_expected.to eq(200) }
      its(:errors) { is_expected.to be_blank }
    end

    context 'with an invalid body' do
      let(:code) { '200' }
      let(:body) do
        {
          lol: 'oki',
        }.to_json
      end

      it { is_expected.to be_a_failure }

      its(:status) { is_expected.to eq(502) }
      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
    end

    context 'with an invalid status code', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
      let(:code) { '418' }
      let(:body) do
        RNM::EntreprisesArtisanales::MakeRequest.call(params: params).response.body
      end

      it { is_expected.to be_a_failure }

      its(:status) { is_expected.to eq(502) }
      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
    end
  end
end
