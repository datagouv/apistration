RSpec.describe SIADE::V2::Drivers::Exercices, type: :provider_driver do
  let(:driver) { described_class.new(siret: siret, driver_options: options).perform_request }
  let(:options) { { user_id: valid_dgfip_user_id, cookie: 'lemondgfip=bf91ce99ea967a4e24fffc2ad76d9145_519c42a2f4f4d80a5a5ff060246caf12; domain=.dgfip.finances.gouv.fr; path=/' } }
  subject { driver }

  context 'when siret is not found', vcr: { cassette_name: 'exercice_with_not_found_siret' } do
    let(:siret) { non_existent_siret }
    its(:http_code) { is_expected.to eq 404 }
  end

  context 'when siret is valid', vcr: { cassette_name: 'exercice_with_valid_siret' } do
    let(:siret) { valid_siret(:exercice) }

    its(:http_code) { is_expected.to eq 200 }
    its(:liste_ca) { is_expected.to be_a_kind_of Array }

    context '#liste_ca item' do
      subject { driver.liste_ca.first }

      its(['ca']) { is_expected.to eq '648374448' }
      its(['date_fin_exercice']) { is_expected.to eq '2016-12-31T00:00:00+01:00' }
      its(['date_fin_exercice_timestamp']) { is_expected.to eq 1483138800 }
    end
  end

  context 'when the siret seems out of scope', vcr: { cassette_name: 'exercice_with_redirect_siret' } do
    let(:siret) { out_of_scope_dgfip }

    its(:http_code) { is_expected.to eq(502) }
    its(:errors) { is_expected.to have_error('Erreur de la DGFIP, celle intervient généralement lorsque l\'organisme n\'est pas soumis à l\'impôt sur les sociétés. Si c\'est bien le cas il est possible que les comptes n\'est pas encore été déposés aux greffes.') }
  end
end
