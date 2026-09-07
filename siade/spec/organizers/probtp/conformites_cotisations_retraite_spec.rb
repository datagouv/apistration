RSpec.describe PROBTP::ConformitesCotisationsRetraite, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:
    }
  end

  context 'when it is ok and conforme' do
    let(:siret) { eligible_siret(:probtp) }

    before { stub_probtp_conformite_eligible }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_a(Resource)
    end
  end

  context 'when it is ok and not conforme' do
    let(:siret) { non_eligible_siret(:probtp) }

    before { stub_probtp_conformite_non_eligible }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_a(Resource)
    end
  end

  context 'when siret is not found' do
    let(:siret) { not_found_siret(:probtp) }

    before { stub_probtp_conformite_not_found }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end
end
