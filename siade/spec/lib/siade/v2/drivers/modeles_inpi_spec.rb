RSpec.describe SIADE::V2::Drivers::ModelesINPI, type: :provider_driver do
  context 'ill formatted json response' do
    subject { described_class.new({ siren: valid_siren }).perform_request }

    let(:ill_formatted_json_siren)      { valid_siren }
    let(:ill_formatted_json)            { '' }

    before do
      stub_request(:get, /opendata-pi.inpi.fr/).to_return(status: 200, body: ill_formatted_json)
    end

    its(:http_code) { is_expected.to eq(502) }
    its(:errors)    { is_expected.to have_error('Echec lors du parsing de la réponse JSON des modèles INPI') }
  end

  context 'not found siren' do
    # We are doing a search, we may return no results at all. 404 and no results are no good here. Maybe we should
    # make a check on existing siren
    it 'has 404 http code'
  end

  context 'valid siren', vcr: { cassette_name: 'modeles_inpi_with_valid_siren' } do
    subject { described_class.new(siren: siren).perform_request }

    let(:siren) { valid_siren(:inpi) }

    its(:siren) { is_expected.to eq(valid_siren(:inpi)) }
    its(:count) { is_expected.to eq(361) }

    context 'latests_modeles' do
      subject { super().latests_modeles }

      its(:class) { is_expected.to eq(Array) }
      its(:size)  { is_expected.to eq(5) }

      context 'latests_modeles sample' do
        subject { super().first }

        its(['date_publication'])    { is_expected.to eq('20170602') }
        its(['date_depot'])          { is_expected.to eq('20140527') }
        its(['numero_identification']) { is_expected.to eq('20142275') }
        its(['titre']) { is_expected.to eq('Véhicule automobile, vues de détails') }
      end
    end
  end
end
