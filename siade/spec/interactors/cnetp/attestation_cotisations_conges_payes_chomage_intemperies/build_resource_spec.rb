RSpec.describe CNETP::AttestationCotisationsCongesPayesChomageIntemperies::BuildResource, type: :build_resource do
  subject { described_class.call(url: 'not.a.real/file/upload', params:) }

  let(:params) do
    {
      siren: valid_siren(:cnetp)
    }
  end

  it { is_expected.to be_success }

  it 'builds valid resource' do
    expect(subject.bundled_data.data).to be_a(Resource)

    expect(subject.bundled_data.data.to_h).to include(
      document_url: 'not.a.real/file/upload'
    )
  end
end
