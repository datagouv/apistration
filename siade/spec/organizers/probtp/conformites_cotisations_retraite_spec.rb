RSpec.describe PROBTP::ConformitesCotisationsRetraite, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:
    }
  end

  context 'when it is ok and conforme', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_eligible_siret' } do
    let(:siret) { eligible_siret(:probtp) }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_a(Resource)
    end
  end

  context 'when it is ok and not conforme', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_non_eligible_siret' } do
    let(:siret) { non_eligible_siret(:probtp) }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_a(Resource)
    end
  end

  context 'when siret is not found', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_not_found_siret' } do
    let(:siret) { not_found_siret(:probtp) }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end
end
