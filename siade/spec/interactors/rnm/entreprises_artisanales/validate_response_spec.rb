require 'rails_helper'

RSpec.describe RNM::EntreprisesArtisanales::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response: response, provider_name: 'CMA France') }

    describe 'with real response' do
      let(:response) { RNM::EntreprisesArtisanales::MakeRequest.call(params: params).response }

      let(:params) do
        {
          siren: siren,
        }
      end

      context 'with a valid siren', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
        let(:siren) { valid_siren(:rnm_cma) }

        it { is_expected.to be_a_success }

        its(:status) { is_expected.to eq(200) }
        its(:errors) { is_expected.to be_empty }
      end

      context 'with a 404', vcr: { cassette_name: 'rnm_cma/not_found_siren' } do
        let(:siren) { not_found_siren(:rnm_cma) }

        it { is_expected.to be_a_failure }

        its(:status) { is_expected.to eq(404) }
        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end
    end

    context 'with stubbed response' do
      let(:response) do
        instance_double('Net::HTTPOK', code: code, body: body)
      end

      context 'with a valid code and an invalid body' do
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

      context 'with an invalid status code' do
        let(:code) { '418' }
        let(:body) do
          {
            id: '123456789',
          }
        end

        it { is_expected.to be_a_failure }

        its(:status) { is_expected.to eq(502) }
        its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
      end
    end
  end
end
