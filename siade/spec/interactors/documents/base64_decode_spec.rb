require 'rails_helper'

describe Documents::Base64Decode do
  subject { described_class.call(decode_params) }

  context 'when the content is a valid base64 encoded string' do
    let(:decode_params) do
      decoded_content = 'clear hello'
      encoded_content = Base64.strict_encode64(decoded_content)

      { content: encoded_content }
    end

    it { is_expected.to be_success }

    its(:content) { is_expected.to eq('clear hello') }
  end

  context 'when the content is not a valid base64 encoded string' do
    let(:decode_params) do
      { content: 'THIS IS F@KE!' }
    end

    it { is_expected.to be_failure }

    its(:errors) { is_expected.to include('Erreur lors du décodage : invalide Base64 format') }
  end
end
