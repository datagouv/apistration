require 'rails_helper'

describe PROBTP::AttestationsCotisationsRetraite::PrepareDocumentStorage do
  describe '.call' do
    subject { described_class.call(response: response) }

    let(:response) { instance_double(Net::HTTPOK, code: code, body: body) }
    let(:code) { 200 }
    let(:body) { '{"what": "ever", "data": "much file content"}' }

    it { is_expected.to be_success }

    its(:file_type) { is_expected.to eq('pdf') }

    its(:filename) { is_expected.to eq('attestation_cotisation_retraite_probtp') }

    its(:content) { is_expected.to eq('much file content') }
  end
end
