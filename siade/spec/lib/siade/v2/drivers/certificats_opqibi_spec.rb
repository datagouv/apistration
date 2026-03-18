RSpec.describe SIADE::V2::Drivers::CertificatsOPQIBI, type: :provider_driver do
  subject { described_class.new({siren: siren}).perform_request }

  context 'when siren unknonw by OPQIBI', vcr: { cassette_name: 'opqibi_with_not_found_siren' } do
    let(:siren) { not_found_siren(:opqibi) }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'when siren known by OPQIBI', vcr: { cassette_name: 'opqibi_with_valid_siren' } do
    let(:siren) { valid_siren(:opqibi) }

    its(:numero_certificat)                               { is_expected.to eq('85 04 0695') }
    its(:date_de_delivrance_du_certificat)                { is_expected.to eq('01/04/2020') }
    its(:duree_de_validite_du_certificat)                 { is_expected.to eq('valable un an') }
    its(:assurance)                                       { is_expected.to eq('ALLIANZ - AXA') }
    its(:url)                                             { is_expected.to eq('http://opqibi.com/fiche.php?id=719') }

    context '#qualifications (non probatoire)' do
      its(:qualifications)                      { is_expected.to be_a(Array) }
      its(:date_de_validite_des_qualifications) { is_expected.to eq('01/04/2022') }

      it 'should have first qualification like' do
        expect(subject.qualifications.first[:code_qualification]).to eq('0103')
        expect(subject.qualifications.first[:nom]).to eq('AMO en technique')
        expect(subject.qualifications.first[:definition]).not_to be_nil
        expect(subject.qualifications.first[:rge]).to eq('0')
      end
    end

    context '#qualifications probatoires' do
      its(:qualifications_probatoires)                      { is_expected.to be_a(Array) }
      its(:date_de_validite_des_qualifications_probatoires) { is_expected.to eq('01/04/2021') }

      it 'should have first qualification probatoire like' do
        expect(subject.qualifications_probatoires.first[:code_qualification]).to eq('1301')
        expect(subject.qualifications_probatoires.first[:nom]).to eq('Étude de réseaux courants de distribution d\'eau')
        expect(subject.qualifications_probatoires.first[:definition]).not_to be_nil
        expect(subject.qualifications_probatoires.first[:rge]).to eq('0')
      end
    end
  end

  context 'when siren have no qualifications probatoires', vcr: { cassette_name: 'opqibi_with_434717997' } do
    let(:siren) { '434717997' }

    its(:qualifications_probatoires)                      { is_expected.to be_a(Array) }
    its(:qualifications_probatoires)                      { is_expected.to be_empty }
    its(:date_de_validite_des_qualifications_probatoires) { is_expected.to be_nil }
  end
end
