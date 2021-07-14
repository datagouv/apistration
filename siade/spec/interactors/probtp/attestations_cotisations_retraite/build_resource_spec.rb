RSpec.describe PROBTP::AttestationsCotisationsRetraite::BuildResource do
  describe '.call' do
    subject { described_class.call(url: 'not.a.real/file/upload', params: params) }

    let(:params) do
      {
        siret: eligible_siret(:probtp),
      }
    end

    it { is_expected.to be_success }

    it 'builds valid resource' do
      expect(subject.resource).to be_a(Resource)

      expect(subject.resource.to_h).to include(
        id: eligible_siret(:probtp),
        document_url: 'not.a.real/file/upload',
      )
    end
  end
end
