RSpec.describe SIADE::V2::Drivers::Infogreffe, type: :provider_driver do
  context 'when siren is not found', vcr: { cassette_name: 'infogreffe_extrait_rcs_with_not_found_siren' } do
    subject { described_class.new(siren: siren).perform_request }
    let(:siren) { not_found_siren(:extrait_rcs) }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'when has multiple nom commercial' do
    let(:siren) { '306138900' }

    subject { described_class.new(siren: siren).tap(&:perform_request) }

    its(:nom_commercial) { is_expected.to eq 'DECATHLON' } # and not DECATHLONDECATHLONDECATHLON

    context 'simulate an empty result to test safe navigation on **nom_commercial_siege_social**' do
      before do
        # The two lines are mandatories (the method is calle multiple times)
        allow_any_instance_of(Nokogiri::XML::Document).to receive(:css).and_call_original
        allow_any_instance_of(Nokogiri::XML::Document).to receive(:css).with('etablissement').and_return nil
      end

      # it will never raise an exception it is rescue in Generic Driver
      its(:nom_commercial) { is_expected.to eq 'DECATHLONDECATHLONDECATHLON' }
      its(:nom_commercial) { is_expected.not_to eq 'Donnée indisponible' }
    end
  end

  context 'when siren is valid', vcr: { cassette_name: 'infogreffe_extrait_rcs_with_valid_siren' } do
    let(:siren) { valid_siren(:extrait_rcs) }
    before do
      remember_through_each_test_of_current_scope('infogreffe_extrait_rcs') do
        described_class.new({siren: siren})
      end
    end

    subject { @infogreffe_extrait_rcs.perform_request }

    its(:siren) { is_expected.to eq(valid_siren(:extrait_rcs)) }
    its(:date_immatriculation) { is_expected.to eq('1998-03-27') }
    its(:date_immatriculation_timestamp) { is_expected.to eq(890953200) }
    its(:date_extrait) { is_expected.to match(/^[0-9]{2}[ ][A-Z]+[ ][0-9]{4}/) }
    its(:forme_juridique) { is_expected.to eq('SOCIETE ANONYME') }
    its(:forme_juridique_code) { is_expected.to eq('SAh') }
    its(:nom_commercial) { is_expected.to eq('OCTO-TECHNOLOGY') }
    its(:capital_social) { is_expected.to eq(509525) }
    its(:date_radiation) { is_expected.to be nil }
    its(:liste_observations) { is_expected.to be_instance_of(Array) }
    its(:mandataires_sociaux) { is_expected.to be_instance_of(Array) }

    context '#liste_observations' do
      subject { @infogreffe_extrait_rcs.perform_request.liste_observations.first }

      it { is_expected.to be_a_kind_of(Hash) }
      its([:date]) { is_expected.to eq('2000-02-23') }
      its([:date_timestamp]) { is_expected.to eq(951260400) }
      its([:numero]) { is_expected.to eq('12197') }
      its([:libelle]) { is_expected.to eq(' LA SOCIETE NE CONSERVE AUCUNE ACTIVITE A SON ANCIEN SIEGE ') }
    end

    context '#mandataires_sociaux' do
      subject { @infogreffe_extrait_rcs.perform_request.mandataires_sociaux.first }

      it { is_expected.to be_a_kind_of(Hash) }
      its([:nom]) { is_expected.to eq('HISQUIN') }
      its([:prenom]) { is_expected.to eq('FRANCOIS') }
      its([:fonction]) { is_expected.to eq('PRESIDENT DU DIRECTOIRE') }
      its([:date_naissance]) { is_expected.to eq('1965-01-27') }
      its([:date_naissance_timestamp]) { is_expected.to eq(-155523600) }
      its([:raison_sociale]) { is_expected.to eq('') }
      its([:identifiant]) { is_expected.to eq('') }
      its([:type]) { is_expected.to eq('PP') }
    end
  end
end
