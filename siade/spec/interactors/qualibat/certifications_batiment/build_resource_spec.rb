require 'rails_helper'

RSpec.describe QUALIBAT::CertificationsBatiment::BuildResource do
  describe '.call' do
    subject { described_class.call(url: 'uploaded/file/url', params:) }

    let(:params) do
      {
        siret: valid_siret(:qualibat)
      }
    end

    it { is_expected.to be_a_success }

    it 'build a valid resource' do
      expect(subject.resource).to be_a(Resource)

      expect(subject.resource.to_h).to include(
        document_url: 'uploaded/file/url'
      )
    end
  end
end
