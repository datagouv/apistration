RSpec.describe SIADE::V2::Drivers::CertificatsRGEADEME, type: :provider_driver do
  context 'when data is not found', vcr: { cassette_name: 'ademe/rge/with_not_found_siret' } do
    subject { @lib_driver_certificats_rge_ademe_spec__init_with_not_found_siret }

    let(:siret) { not_found_siret(:rge_ademe) }

    before do
      remember_through_each_test_of_current_scope('lib_driver_certificats_rge_ademe_spec__init_with_not_found_siret') do
        described_class.new(siret: siret).perform_request
      end
    end

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'when data is found', vcr: { cassette_name: 'ademe/rge/with_valid_siret' } do
    let(:siret) { valid_siret(:rge_ademe) }

    describe '#qualifications' do
      context 'when PDF document are not wanted' do
        subject { @lib_driver_certificats_rge_ademe_qualifs_spec_no_pdf__init_with_valid_siret.qualifications }

        before do
          remember_through_each_test_of_current_scope('lib_driver_certificats_rge_ademe_qualifs_spec_no_pdf__init_with_valid_siret') do
            described_class.new(siret: siret, user_params: { skip_pdf: true }).perform_request
          end
        end

        # rubocop:disable Metrics/BlockLength
        it do
          expect(subject).to contain_exactly(
            a_hash_including({
              nom: 'Qualisol - Pose de chauffe-eau solaire individuel (eau chaude solaire)',
              nom_certificat: 'Qualisol CESI',
              url_certificat: nil
            }),
            a_hash_including({
              nom: 'Qualibois module Eau - Pose d\'appareil de chauffage au bois hydraulique (chaudière bois et poêle)',
              nom_certificat: 'Qualibois module Eau',
              url_certificat: nil
            }),
            a_hash_including({
              nom: 'QualiPAC Chauffage - Pose de pompe à chaleur (PAC aérothermique ou géothermique et chauffe-eau thermodynamique)',
              nom_certificat: 'QualiPAC Chauffage',
              url_certificat: nil
            }),
            a_hash_including({
              nom: 'Efficacité énergétique - "ECO Artisan®" - Chauffagiste',
              nom_certificat: 'QUALIBAT-RGE',
              url_certificat: nil
            }),
            a_hash_including({
              nom: 'Efficacité énergétique - "ECO Artisan®" - Chauffagiste',
              nom_certificat: 'QUALIBAT-RGE',
              url_certificat: nil
            })
          )
        end
        # rubocop:enable Metrics/BlockLength
      end

      context 'without the option not to upload the PDF' do
        subject { @lib_driver_certificats_rge_ademe_qualifs_spec__init_with_valid_siret.qualifications }

        before do
          remember_through_each_test_of_current_scope('lib_driver_certificats_rge_ademe_qualifs_spec__init_with_valid_siret') do
            described_class.new(siret: siret).perform_request
          end
        end

        # rubocop:disable Metrics/BlockLength
        it do
          expect(subject).to contain_exactly(
            a_hash_including({
              nom: 'Qualisol - Pose de chauffe-eau solaire individuel (eau chaude solaire)',
              nom_certificat: 'Qualisol CESI',
              url_certificat: a_string_starting_with(Siade.credentials[:public_storage_url]).and(a_string_ending_with('-certificat_rge_ademe.pdf'))
            }),
            a_hash_including({
              nom: 'Qualibois module Eau - Pose d\'appareil de chauffage au bois hydraulique (chaudière bois et poêle)',
              nom_certificat: 'Qualibois module Eau',
              url_certificat: a_string_starting_with(Siade.credentials[:public_storage_url]).and(a_string_ending_with('-certificat_rge_ademe.pdf'))
            }),
            a_hash_including({
              nom: 'QualiPAC Chauffage - Pose de pompe à chaleur (PAC aérothermique ou géothermique et chauffe-eau thermodynamique)',
              nom_certificat: 'QualiPAC Chauffage',
              url_certificat: a_string_starting_with(Siade.credentials[:public_storage_url]).and(a_string_ending_with('-certificat_rge_ademe.pdf'))
            }),
            a_hash_including({
              nom: 'Efficacité énergétique - "ECO Artisan®" - Chauffagiste',
              nom_certificat: 'QUALIBAT-RGE',
              url_certificat: a_string_starting_with(Siade.credentials[:public_storage_url]).and(a_string_ending_with('-certificat_rge_ademe.pdf'))
            }),
            a_hash_including({
              nom: 'Efficacité énergétique - "ECO Artisan®" - Chauffagiste',
              nom_certificat: 'QUALIBAT-RGE',
              url_certificat: a_string_starting_with(Siade.credentials[:public_storage_url]).and(a_string_ending_with('-certificat_rge_ademe.pdf'))
            })
          )
        end
        # rubocop:enable Metrics/BlockLength
      end

      context 'when an error occurs with at least one document' do
        subject { @lib_driver_certificats_rge_ademe_qualifs_spec__init_with_valid_siret_pdf_fails }

        before do
          remember_through_each_test_of_current_scope('lib_driver_certificats_rge_ademe_qualifs_spec__init_with_valid_siret_pdf_fails') do
            described_class.new(siret: siret).perform_request
          end

          allow_any_instance_of(SIADE::SelfHostedDocument::File::PDF).to receive(:success?).and_return(false)
          allow_any_instance_of(SIADE::SelfHostedDocument::File::PDF).to receive(:errors).and_return([[:invalid_extension, 'An error occured']])
          @lib_driver_certificats_rge_ademe_qualifs_spec__init_with_valid_siret_pdf_fails.qualifications
        end

        its(:http_code) { is_expected.to eq(502) }
        its(:errors) { is_expected.to have_error('An error occured') }
      end
    end

    describe '#domaines' do
      subject { @lib_driver_certificats_rge_ademe_domaines_spec__init_with_valid_siret.domaines }

      before do
        remember_through_each_test_of_current_scope('lib_driver_certificats_rge_ademe_domaines_spec__init_with_valid_siret') do
          described_class.new(siret: siret).perform_request
        end
      end

      it do
        expect(subject).to contain_exactly(
          'Chaudière condensation ou micro-cogénération gaz ou fioul',
          'Radiateurs électriques, dont régulation.',
          'Chauffage et/ou eau chaude solaire',
          'Poêle ou insert bois',
          'Chaudière bois',
          'Pompe à chaleur : chauffage'
        )
      end
    end
  end

  context 'when data is found but there is an unexpected error', vcr: { cassette_name: 'ademe/rge/with_valid_siret' } do
    subject { described_class.new(siret: siret).perform_request }

    let(:siret) { valid_siret(:rge_ademe) }

    before do
      allow_any_instance_of(described_class).to receive(:url_certificat_payload).and_raise(StandardError)
    end

    it 'raises an error' do
      expect do
        subject.qualifications
      end.to raise_error(StandardError)
    end
  end

  describe 'non regression test: when domaines is a flat array', vcr: { cassette_name: 'ademe/rge/non_regression_domaines_flat' } do
    let(:siret) { '83401500000021' }

    subject { described_class.new(siret: siret).perform_request }

    it 'works' do
      expect(subject.domaines).to eq([
        "Travaux d'installation électrique dans tous locaux"
      ])
    end
  end

  describe 'non regression test: when provider is found and there is an extra payload which describes the response', vcr: { cassette_name: 'ademe/rge/with_valid_siret_and_extra_payload_which_describe_the_payload' } do
    let(:siret) { valid_siret(:rge_ademe) }

    subject { described_class.new(siret: siret).perform_request }

    it 'works' do
      expect(subject.domaines.count).to be >= 2
      expect(subject.domaines).to include(
        'Pompe à chaleur : chauffage'
      )
    end
  end

  describe 'non regression test: when provider is not found and there is an extra payload which describes the response', vcr: { cassette_name: 'ademe/rge/with_not_found_siret_and_extra_payload_which_describe_the_payload' } do
    let(:siret) { not_found_siret(:rge_ademe) }

    subject { described_class.new(siret: siret).perform_request }

    its(:http_code) { is_expected.to eq(404) }
  end

  describe 'non regression test: when qualifications is an empty string', vcr: { cassette_name: 'ademe/rge/non_regression_qualifications_empty_string' } do
    let(:siret) { '79228853200015' }

    subject { instance.qualifications }

    let(:instance) { described_class.new(siret: siret) }

    before do
      instance.perform_request
      instance.check_response
    end

    it 'works and renders an empty array' do
      expect(subject).to eq([])
    end
  end

  describe 'non regression test: when there is a pdf from qualypso and there is an error', vcr: { cassette_name: 'ademe/rge/with_valid_siret' } do
    subject { instance }

    let(:instance) { described_class.new(siret: siret) }
    let(:siret) { valid_siret(:rge_ademe) }
    let(:qualypso_document_url) { 'https://www.qualypso.fr/download_file.php?id=fd03fdfe-ba4c-448e-8e05-cfd30a6d2ebb' }
    let(:sample_error) do
      [
        SocketError,
        OpenSSL::SSL::SSLError,
        OpenURI::HTTPError.new('whatever', 'whatever')
      ].sample
    end

    before do
      stub_request(:get, qualypso_document_url).to_raise(sample_error)

      instance.perform_request
      instance.check_response
      instance.qualifications
    end

    its(:http_code) { is_expected.to eq(502) }
    its(:errors) { is_expected.to have_error('Something\'s wrong with some files from Qualypso, retry later') }
  end
end
