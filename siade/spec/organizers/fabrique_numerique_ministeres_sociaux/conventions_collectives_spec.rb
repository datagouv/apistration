RSpec.describe FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:
    }
  end

  context 'when siret is valid' do
    let(:siret) { valid_siret(:conventions_collectives) }

    before { stub_fabrique_numerique_conventions_collectives_valid }

    it { is_expected.to be_success }

    it 'retrieves the resource collection' do
      resource_collection = subject.bundled_data.data

      expect(resource_collection).to be_present
    end

    it 'has meta' do
      meta = subject.bundled_data.context

      expect(meta).to be_present
    end
  end

  context 'when siret is not found' do
    let(:siret) { not_found_siret(:conventions_collectives) }

    before { stub_fabrique_numerique_conventions_collectives_not_found }

    it { is_expected.to be_a_failure }
  end
end
