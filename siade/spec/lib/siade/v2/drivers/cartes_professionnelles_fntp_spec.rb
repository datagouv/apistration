RSpec.describe SIADE::V2::Drivers::CartesProfessionnellesFNTP, :self_hosted_doc, type: :provider_driver do
  subject { described_class.new(siren: siren).perform_request }

  context 'siren inconnu chez FNTP', vcr: { cassette_name: 'fntp/carte_professionnelle_travaux_publics/not_found_siren' } do
    let(:siren) { non_existent_siren }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'siren eligible au certificat FNTP', vcr: { cassette_name: 'fntp/carte_professionnelle_travaux_publics/valid_siren' } do
    let(:siren) { valid_siren(:fntp) }

    context 'with a valid PDF content' do
      its(:http_code) { is_expected.to eq(200) }
      its(:document_url) { is_expected.to be_a_valid_self_hosted_pdf_url('carte_professionnelle_fntp') }
    end

    context 'with a invalid PDF content' do
      before do
        url = 'http://rip.fntp.fr/rip/sgmap/'
        stub_request(:get, /#{url}/)
          .to_return({ status: 200, body: 'no pdf here' })
      end

      its(:http_code) { is_expected.to eq(502) }
      its(:errors) { is_expected.to have_error(bad_pdf_error_message) }
    end
  end
end
