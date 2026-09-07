RSpec.describe Infogreffe::MandatairesSociaux, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren:
      }
    end

    context 'with valid siren' do
      let(:siren) { valid_siren(:extrait_rcs) }

      before { stub_infogreffe_personne_morale }

      it { is_expected.to be_a_success }

      it 'retrieves the resource collection' do
        expect(subject.bundled_data.data).to be_present
      end

      it 'has meta' do
        expect(subject.bundled_data.context).to be_present
      end
    end

    context 'with invalid siren' do
      let(:siren) { not_found_siren(:extrait_rcs) }

      before { stub_infogreffe_siren_not_found }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'with a payload which has no mandataires sociaux' do
      let(:siren) { valid_siren }

      before do
        stub_request(:post, /#{Siade.credentials[:infogreffe_url_extrait_rcs]}/).to_return(
          status: 200,
          body: open_payload_file('infogreffe/without_mandataire.xml')
        )
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'with a payload which has personne morale and personne physique' do
      let(:siren) { valid_siren }

      before do
        stub_request(:post, /#{Siade.credentials[:infogreffe_url_extrait_rcs]}/).to_return(
          status: 200,
          body: open_payload_file('infogreffe/with_pp_and_pm.xml')
        )
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource collection with both kind of mandataire social' do
        expect(subject.bundled_data.data).to be_present
        expect(subject.bundled_data.data.map(&:type)).to match_array(%w[personne_morale personne_physique])
      end
    end
  end
end
