RSpec.describe CIBTP::AttestationsCotisationsChomageIntemperies::BuildResource, type: :build_resource do
  subject { described_class.call(url: 'not.a.real/file/upload', params:) }

  let(:params) do
    {
      siret: valid_siret
    }
  end

  let(:resource) { subject.bundled_data.data }

  it { is_expected.to be_success }

  it 'builds valid resource' do
    expect(resource).to be_a(Resource)

    expect(resource.to_h).to include(
      document_url: 'not.a.real/file/upload'
    )
  end
end
