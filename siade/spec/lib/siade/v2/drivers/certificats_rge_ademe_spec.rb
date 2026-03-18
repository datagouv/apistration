RSpec.describe SIADE::V2::Drivers::CertificatsRGEAdeme, type: :provider_driver do
  context 'when data is not found', vcr: { cassette_name: 'ademe/rge/with_not_found_siret' } do
    let(:siret) { not_found_siret(:rge_ademe) }

    before do
      remember_through_each_test_of_current_scope('lib_driver_certificats_rge_ademe_spec__init_with_not_found_siret') do
        described_class.new(siret: siret).perform_request
      end
    end

    subject { @lib_driver_certificats_rge_ademe_spec__init_with_not_found_siret }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'when data is found', vcr: { cassette_name: 'ademe/rge/with_valid_siret' } do
    let(:siret) { valid_siret(:rge_ademe) }

    context '#qualifications' do
      context 'when PDF document are not wanted' do
        before do
          remember_through_each_test_of_current_scope('lib_driver_certificats_rge_ademe_qualifs_spec_no_pdf__init_with_valid_siret') do
            described_class.new(siret: siret, user_params: { skip_pdf: true }).perform_request
          end
        end

        subject { @lib_driver_certificats_rge_ademe_qualifs_spec_no_pdf__init_with_valid_siret.qualifications }

        it do
          is_expected.to contain_exactly(
            a_hash_including({
              nom:            'Qualisol - Pose de chauffe-eau solaire individuel (eau chaude solaire)',
              nom_certificat: 'Qualisol CESI',
              url_certificat: nil
            }),
            a_hash_including({
              nom:            'Qualibois module Eau - Pose d\'appareil de chauffage au bois hydraulique (chaudière bois et poêle)',
              nom_certificat: 'Qualibois module Eau',
              url_certificat: nil
            }),
            a_hash_including({
              nom:            'QualiPAC Chauffage - Pose de pompe à chaleur (PAC aérothermique ou géothermique et chauffe-eau thermodynamique)',
              nom_certificat: 'QualiPAC Chauffage',
              url_certificat: nil
            }),
            a_hash_including({
              nom:            'Efficacité énergétique - "ECO Artisan®" - Chauffagiste',
              nom_certificat: 'QUALIBAT-RGE',
              url_certificat: nil
            }),
            a_hash_including({
              nom:            'Efficacité énergétique - "ECO Artisan®" - Chauffagiste',
              nom_certificat: 'QUALIBAT-RGE',
              url_certificat: nil
            })
          )
        end
      end

      context 'without the option not to upload the PDF' do
        before do
          remember_through_each_test_of_current_scope('lib_driver_certificats_rge_ademe_qualifs_spec__init_with_valid_siret') do
            described_class.new(siret: siret).perform_request
          end
        end

        subject { @lib_driver_certificats_rge_ademe_qualifs_spec__init_with_valid_siret.qualifications }

        it do
          is_expected.to contain_exactly(
            a_hash_including({
              nom:            'Qualisol - Pose de chauffe-eau solaire individuel (eau chaude solaire)',
              nom_certificat: 'Qualisol CESI',
              url_certificat: a_string_starting_with(Siade.credentials[:public_storage_url]).and(a_string_ending_with('-certificat_rge_ademe.pdf'))
            }),
            a_hash_including({
              nom:            'Qualibois module Eau - Pose d\'appareil de chauffage au bois hydraulique (chaudière bois et poêle)',
              nom_certificat: 'Qualibois module Eau',
              url_certificat: a_string_starting_with(Siade.credentials[:public_storage_url]).and(a_string_ending_with('-certificat_rge_ademe.pdf'))
            }),
            a_hash_including({
              nom:            'QualiPAC Chauffage - Pose de pompe à chaleur (PAC aérothermique ou géothermique et chauffe-eau thermodynamique)',
              nom_certificat: 'QualiPAC Chauffage',
              url_certificat: a_string_starting_with(Siade.credentials[:public_storage_url]).and(a_string_ending_with('-certificat_rge_ademe.pdf'))
            }),
            a_hash_including({
              nom:            'Efficacité énergétique - "ECO Artisan®" - Chauffagiste',
              nom_certificat: 'QUALIBAT-RGE',
              url_certificat: a_string_starting_with(Siade.credentials[:public_storage_url]).and(a_string_ending_with('-certificat_rge_ademe.pdf'))
            }),
            a_hash_including({
              nom:            'Efficacité énergétique - "ECO Artisan®" - Chauffagiste',
              nom_certificat: 'QUALIBAT-RGE',
              url_certificat: a_string_starting_with(Siade.credentials[:public_storage_url]).and(a_string_ending_with('-certificat_rge_ademe.pdf'))
            })
          )
        end
      end

      context 'when an error occurs with at least one document' do
        before do
          remember_through_each_test_of_current_scope('lib_driver_certificats_rge_ademe_qualifs_spec__init_with_valid_siret_pdf_fails') do
            described_class.new(siret: siret).perform_request
          end

          allow_any_instance_of(SIADE::SelfHostedDocument::File::PDF).to receive(:success?).and_return(false)
          allow_any_instance_of(SIADE::SelfHostedDocument::File::PDF).to receive(:errors).and_return([[:invalid_extension, 'An error occured']])
          @lib_driver_certificats_rge_ademe_qualifs_spec__init_with_valid_siret_pdf_fails.qualifications
        end

        subject { @lib_driver_certificats_rge_ademe_qualifs_spec__init_with_valid_siret_pdf_fails }

        its(:http_code) { is_expected.to eq(502) }
        its(:errors) { is_expected.to have_error('An error occured') }
      end
    end

    context '#domaines' do
      before do
        remember_through_each_test_of_current_scope('lib_driver_certificats_rge_ademe_domaines_spec__init_with_valid_siret') do
          described_class.new(siret: siret).perform_request
        end
      end

      subject { @lib_driver_certificats_rge_ademe_domaines_spec__init_with_valid_siret.domaines }

      it do
        is_expected.to contain_exactly(
          'Chaudière condensation ou micro-cogénération gaz ou fioul',
          'Radiateurs électriques, dont régulation.',
          'Chauffage et/ou eau chaude solaire',
          'Poêle ou insert bois',
          'Chaudière bois',
          'Pompe à chaleur : chauffage',
        )
      end
    end
  end
end
