RSpec.describe SIADE::V2::Drivers::CotisationsMSA, type: :provider_driver do
  context 'Recovering data from MSA API with valid siret', vcr: { cassette_name: 'non_regenerable/msa_web_service_cotisation_valid_siret' } do
    subject { @lib_driver_cotisation_msa_spec__init_with_valid_siret }

    let(:siret) { valid_siret(:msa) }

    before do
      remember_through_each_test_of_current_scope('lib_driver_cotisation_msa_spec__init_with_valid_siret') do
        described_class.new(siret: siret).perform_request
      end
    end

    its(:analyse_en_cours?) { is_expected.to be false }
    its(:a_jour?)           { is_expected.to be true }
  end

  context 'Recovering data from MSA API with pending siret', vcr: { cassette_name: 'non_regenerable/msa_web_service_cotisation_pending_siret' } do
    subject { @lib_driver_cotisation_msa_spec__init_with_pending_siret }

    let(:siret) { valid_siret(:msa_pending) }

    before do
      remember_through_each_test_of_current_scope('lib_driver_cotisation_msa_spec__init_with_pending_siret') do
        described_class.new(siret: siret).perform_request
      end
    end

    its(:analyse_en_cours?) { is_expected.to be true }
    its(:a_jour?)           { is_expected.to be nil }
  end

  context 'Recovering data from MSA with not up to date SIRET' do
    subject { described_class.new(siret: valid_siret).perform_request }

    before do
      stub_request(:get, "https://msa_conformites_cotisations_url.gouv.fr/#{valid_siret}")
        .to_return(status: 200, body: '{ "TopRMPResponse" : { "identifiantDebiteur" : "00701042400039", "topRegMarchePublic" : "N" }}')
    end

    its(:analyse_en_cours?) { is_expected.to be false }
    its(:a_jour?)           { is_expected.to be false }
  end

  context 'Recovering data from MSA failed on MSA side' do
    subject { described_class.new(siret: valid_siret).perform_request }

    before do
      stub_request(:get, "https://msa_conformites_cotisations_url.gouv.fr/#{valid_siret}")
        .to_return(status: 200, body: '{ "TopRMPResponse" : { "identifiantDebiteur" : "00701042400039", "topRegMarchePublic" : "S" }}')
    end

    its(:analyse_en_cours?) { is_expected.to be false }
    its(:a_jour?)           { is_expected.to be false }
  end
end
