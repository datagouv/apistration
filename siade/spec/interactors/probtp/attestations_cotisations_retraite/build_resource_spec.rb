require 'rails_helper'

describe PROBTP::AttestationsCotisationsRetraite::BuildResource do
  describe '.call' do
    subject { described_class.call(url: 'not.a.real/file/upload') }

    it { is_expected.to be_success }

    its(:resource) do
      is_expected.to include(
        document_url: 'not.a.real/file/upload',
      )
    end
  end
end
