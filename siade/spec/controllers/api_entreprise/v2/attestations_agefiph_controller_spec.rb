RSpec.describe APIEntreprise::V2::AttestationsAGEFIPHController, type: :controller do
  let(:token) { yes_jwt }
  let(:mock_agefiph_driver) do
    allow_any_instance_of(SIADE::V2::Drivers::AttestationsAGEFIPH).to receive(:siret_found_in_agefiph_microservice?).and_return(true)

    allow_any_instance_of(SIADE::V2::Drivers::AttestationsAGEFIPH).to receive(:derniere_annee_de_conformite_connue).and_return(derniere_annee_de_conformite_connue)
    allow_any_instance_of(SIADE::V2::Drivers::AttestationsAGEFIPH).to receive(:dump_date).and_return(dump_date)
  end
  let(:derniere_annee_de_conformite_connue) { '2016' }
  let(:dump_date) { Time.now.to_i }

  let(:dump_date) { Time.now.to_i }
  let(:derniere_annee_de_conformite_connue) { '2016' }
  let(:mock_agefiph_driver) do
    allow_any_instance_of(SIADE::V2::Drivers::AttestationsAGEFIPH).to receive(:siret_found_in_agefiph_microservice?).and_return(true)

    allow_any_instance_of(SIADE::V2::Drivers::AttestationsAGEFIPH).to receive(:derniere_annee_de_conformite_connue).and_return(derniere_annee_de_conformite_connue)
    allow_any_instance_of(SIADE::V2::Drivers::AttestationsAGEFIPH).to receive(:dump_date).and_return(dump_date)
  end

  before do
    mock_agefiph_driver
  end

  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity', :show, :siret
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  context do
    before do
      allow_any_instance_of(SIADE::V2::Drivers::AttestationsAGEFIPH).to receive(:siret_found_in_agefiph_microservice?).and_return(false)
    end

    it_behaves_like 'not_found'
  end

  describe 'happy path' do
    subject { response }

    before do
      get :show, params: {
        siret: valid_siret(:agefiph),
        token: token
      }.merge(mandatory_params)
    end

    its(:status) { is_expected.to eq(200) }

    it 'has derniere_annee_de_conformite_connue and dump_date' do
      body = JSON.parse(response.body)
      expect(body['derniere_annee_de_conformite_connue']).to eq(derniere_annee_de_conformite_connue)
      expect(body['dump_date']).to eq(dump_date)
    end
  end
end
