RSpec.describe SIADE::V2::Drivers::BrevetsINPI, type: :provider_driver do
  context 'ill formatted json response' do
    subject { described_class.new({ siren: valid_siren }).perform_request }

    let(:ill_formatted_json_siren)      { valid_siren }
    let(:ill_formatted_json)            { '' }

    before do
      stub_request(:get, /opendata-pi.inpi.fr/).to_return(status: 200, body: ill_formatted_json)
    end

    its(:http_code) { is_expected.to eq(502) }
    its(:errors)    { is_expected.to have_error('Echec lors du parsing de la réponse JSON des brevets INPI') }
  end

  context 'valid siren', vcr: { cassette_name: 'brevets_inpi_with_valid_siren' } do
    subject { described_class.new(siren: siren).perform_request }

    let(:siren) { valid_siren(:inpi) }

    its(:siren) { is_expected.to eq(valid_siren(:inpi)) }
    its(:count) { is_expected.to eq(13_139) }

    context 'latests_brevets' do
      subject { super().latests_brevets }

      its(:class) { is_expected.to eq(Array) }
      its(:size)  { is_expected.to eq(5) }

      context 'latests_brevets sample' do
        subject { super().first }

        its(['date_publication'])    { is_expected.to eq('20170609') }
        its(['date_depot'])          { is_expected.to eq('20151203') }
        its(['numero_publication'])  { is_expected.to eq('<country>FR</country><doc-number>3044754</doc-number><kind>A1</kind>') }
        its(['titre'])               { is_expected.to eq('GABARIT DE CONTROLE DE LA POSITION D’UN BORD DE CREVE DE LECHE VITRE DE PORTIERE DE VEHICULE AUTOMOBILE') }
      end
    end
  end
end
