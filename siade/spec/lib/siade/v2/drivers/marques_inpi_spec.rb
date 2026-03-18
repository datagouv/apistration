RSpec.describe SIADE::V2::Drivers::MarquesINPI, type: :provider_driver do
  context 'ill formatted json response' do
    let(:ill_formatted_json_siren)      { valid_siren }
    let(:ill_formatted_json)            { '' }

    subject{ described_class.new({ siren: valid_siren }).perform_request }

    before do
      stub_request(:get, /opendata-pi.inpi.fr/).to_return(status: 200, body: ill_formatted_json)
    end

    its(:http_code) { is_expected.to eq(502) }
    its(:errors)    { is_expected.to have_error('Echec lors du parsing de la réponse JSON des marques INPI') }
  end

  context 'not found siren' do
    # We are doing a search, we may return no results at all. 404 and no results are no good here. Maybe we should
    # make a check on existing siren
    it 'has 404 http code'
  end

  context 'valid siren', vcr: { cassette_name: 'marques_inpi_with_valid_siren' } do
    let(:siren) { valid_siren(:inpi) }

    subject { described_class.new(siren: siren).perform_request }

    its(:siren) { is_expected.to eq(valid_siren(:inpi)) }
    its(:count) { is_expected.to eq(16) }

    context 'latests_marques' do
      subject{ super().latests_marques }

      its(:class) { is_expected.to eq(Array) }
      its(:size)  { is_expected.to eq(5) }

      context 'latests_marques sample' do
        subject{ super().first }

        its(['numero_identification'])  { is_expected.to eq("4313413") }
        its(['marque'])                 { is_expected.to be nil }
        its(['marque_status'])          { is_expected.to eq("Marque enregistrée") }
        its(['depositaire'])            { is_expected.to eq("PEUGEOT CITROËN AUTOMOBILES SA, Société anonyme") }
        its(['cle'])                    { is_expected.to eq("FMARK|4313413") }
      end
    end
  end
end
