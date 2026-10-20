RSpec.describe Admin::TopUserQuery do
  subject(:query) { described_class.new(Admin::StatisticsFilter.new(date_from: 3.days.ago.to_date, date_to: Date.current)) }

  let(:insee) { 'api_entreprise/v3_and_more/insee/etablissements' }
  let(:editor_request) { create(:authorization_request, demarche: 'editeur-x', external_id: 'DP-1') }
  let(:direct_request) { create(:authorization_request, demarche: nil, external_id: 'DP-2') }
  let(:editor_token) { create(:token, authorization_request: editor_request) }
  let(:direct_token) { create(:token, authorization_request: direct_request) }

  before do
    create_list(:access_log, 2, controller: insee, status: '200', token: editor_token, ip: '1.1.1.1')
    create(:access_log, controller: insee, status: '200', token: direct_token, ip: '2.2.2.2')
    create(:access_log, controller: 'api_particulier/v3_and_more/cnav/quotient_familial', status: '200', token: direct_token, ip: '2.2.2.2')
  end

  it 'ranks editors by the démarche of their habilitations' do
    expect(query.top_editors('entreprise')).to eq([{ identifier: 'editeur-x', calls: 2 }])
  end

  it 'ranks datapass with their siret and intitulé' do
    expect(query.top_datapass('entreprise')).to eq(
      [
        { identifier: 'DP-1', api: 'entreprise', siret: editor_request.siret, intitule: editor_request.intitule, calls: 2 },
        { identifier: 'DP-2', api: 'entreprise', siret: direct_request.siret, intitule: direct_request.intitule, calls: 1 }
      ]
    )
  end

  it 'ranks tokens on the calls to the endpoints of the domain' do
    expect(query.top_tokens('entreprise')).to eq([{ identifier: editor_token.id, calls: 2 }, { identifier: direct_token.id, calls: 1 }])
  end

  it 'ranks IP addresses on the calls of the habilitations of the domain, whatever the endpoint' do
    expect(query.top_ips('entreprise')).to contain_exactly({ identifier: '1.1.1.1', calls: 2 }, { identifier: '2.2.2.2', calls: 2 })
  end
end
