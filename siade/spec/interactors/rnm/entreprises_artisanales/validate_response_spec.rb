require 'rails_helper'

RSpec.describe RNM::EntreprisesArtisanales::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response: response) }

    let(:response) do
      double('response', code: code, body: body)
    end

    context 'with valid response' do
      let(:code) { '200' }
      let(:body) do
        YAML.load_file('spec/fixtures/cassettes/rnm_cma/valid_siren_json.yml')['http_interactions'][0]['response']['body']['string']
      end

      it { is_expected.to be_a_success }
    end

    context 'with an invalid body' do
      let(:code) { '200' }
      let(:body) do
        {
          lol: 'oki',
        }.to_json
      end

      it { is_expected.to be_a_failure }
    end

    context 'with an invalid status code' do
      let(:code) { '418' }
      let(:body) do
        YAML.load_file('spec/fixtures/cassettes/rnm_cma/valid_siren_json.yml')['http_interactions'][0]['response']['body']['string']
      end

      it { is_expected.to be_a_failure }
    end
  end
end
