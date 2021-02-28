require 'rails_helper'

describe PROBTP::AttestationsCotisationsRetraite::MakeRequest do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        siret: siret,
      }
    end

    context 'with a well formatted siret' do
      context 'when the siret is eligible for the attestation', vcr: { cassette_name: 'probtp/attestation/with_eligible_siret', record: :once } do
        let(:siret) { eligible_siret(:probtp) }

        it { is_expected.to be_success }

        its(:response) { is_expected.to be_a(Net::HTTPOK) }
      end
    end
  end
end
