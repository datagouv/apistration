RSpec.describe QUALIBAT::CertificationsBatiment, :retriever do
  subject(:call_retriever) { described_class.call(params:) }

  let(:params) do
    {
      siret:,
      api_version:
    }
  end

  context 'with api version 3' do
    let(:siret) { valid_siret(:qualibat) }
    let(:api_version) { '3' }

    context 'when siret is valid', vcr: { cassette_name: 'qualibat/certifications_batiment/valid_siret_2' } do
      let(:siret) { valid_siret(:qualibat) }

      it { is_expected.to be_a_success }

      it 'does not call extractor' do
        expect(QUALIBATCertificationsBatimentExtractor).not_to receive(:new)

        call_retriever
      end

      it 'renders valid data, with empty extraction' do
        data_as_hash = call_retriever.bundled_data.data.to_h

        expect(data_as_hash[:document_url]).to match(%r{https://.*certificat_qualibat.pdf$})
        expect(data_as_hash[:document_url_expires_in]).to eq(86_400)
        expect(data_as_hash.slice(:date_emission, :date_fin_validite, :entity)).to eq(
          date_emission: nil,
          date_fin_validite: nil,
          entity: {
            assurance_responsabilite_travaux: {
              nom: nil,
              numero: nil
            },
            assurance_responsabilite_civile: {
              nom: nil,
              numero: nil
            },
            certifications: []
          }
        )
      end
    end

    context 'when siret is not found', vcr: { cassette_name: 'qualibat/certifications_batiment/not_found_siret_2' } do
      let(:siret) { not_found_siret(:qualibat) }

      it { is_expected.to be_a_failure }

      it 'does not call extractor' do
        expect(QUALIBATCertificationsBatimentExtractor).not_to receive(:new)

        call_retriever
      end

      its(:errors) { is_expected.to have_error('L\'identifiant indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l\'API.') }
    end
  end

  context 'with api version 4 or more' do
    let(:api_version) { rand(4..9001).to_s }
    let(:extractor) { instance_double(QUALIBATCertificationsBatimentExtractor, perform: extractor_result) }
    let(:extractor_result) do
      YAML.load(ERB.new(Rails.root.join('spec/support/qualibat_certifications_batiment_extractor_tests.yml.erb').read).result(binding), permitted_classes: [Date, Symbol]).first[:data]
    end

    before do
      allow(QUALIBATCertificationsBatimentExtractor).to receive(:new).and_return(extractor)
    end

    context 'with valid siret', vcr: { cassette_name: 'qualibat/certifications_batiment/valid_siret_2' } do
      let(:siret) { valid_siret(:qualibat) }

      it 'calls extractor' do
        expect(extractor).to receive(:perform)

        call_retriever
      end

      it { is_expected.to be_a_success }

      it 'renders valid data, with extracted data' do
        data_as_hash = call_retriever.bundled_data.data.to_h

        expect(data_as_hash[:document_url]).to match(%r{https://.*certificat_qualibat.pdf$})
        expect(data_as_hash[:document_url_expires_in]).to eq(86_400)
        expect(data_as_hash.slice(:date_emission, :date_fin_validite, :entity)).to eq(extractor_result)
      end
    end

    context 'when siret is not found', vcr: { cassette_name: 'qualibat/certifications_batiment/not_found_siret_2' } do
      let(:siret) { not_found_siret(:qualibat) }

      it { is_expected.to be_a_failure }

      it 'does not call extractor' do
        expect(QUALIBATCertificationsBatimentExtractor).not_to receive(:new)

        call_retriever
      end

      its(:errors) { is_expected.to have_error('L\'identifiant indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l\'API.') }
    end
  end
end
