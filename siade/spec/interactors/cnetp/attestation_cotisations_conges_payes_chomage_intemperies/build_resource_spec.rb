RSpec.describe CNETP::AttestationCotisationsCongesPayesChomageIntemperies::BuildResource, type: :build_resource do
  subject { described_class.call(url: 'not.a.real/file/upload', params: params) }

  let(:params) do
    {
      siren: valid_siren(:cnetp)
    }
  end

  it { is_expected.to be_success }

  it 'builds valid resource' do
    expect(subject.resource).to be_a(Resource)

    expect(subject.resource.to_h).to include(
      id: valid_siren(:cnetp),
      document_url: 'not.a.real/file/upload'
    )
  end
end
