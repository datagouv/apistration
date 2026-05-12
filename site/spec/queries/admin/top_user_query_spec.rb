RSpec.describe Admin::TopUserQuery do
  subject(:query) { described_class.new(filter) }

  let(:filter) { Admin::StatisticsFilter.new }
  let(:controller_name) { 'api_entreprise/v3_and_more/insee/etablissements' }

  let(:token) { create(:token) }
  let(:other_token) { create(:token) }

  before do
    create(:access_log, controller: controller_name, status: '200', token: token)
    create(:access_log, controller: controller_name, status: '200', token: token)
    create(:access_log, controller: controller_name, status: '200', token: other_token)
  end

  describe '#top_tokens' do
    it 'groups by token and returns call counts' do
      result = query.top_tokens('entreprise')

      expect(result.size).to eq(2)
      top = result.first
      expect(top[:calls]).to eq(2)
      expect(top[:identifier]).to eq(token.id)
    end

    it 'limits to 10 results' do
      expect(query.top_tokens('entreprise').size).to be <= 10
    end
  end

  describe '#top_datapass' do
    it 'groups by authorization request external_id' do
      result = query.top_datapass('entreprise')

      expect(result).to be_an(Array)
      expect(result.first).to include(:identifier, :calls)
    end
  end

  describe '#top_editors' do
    let(:editor) { create(:editor, :delegable) }

    before do
      EditorDelegation.create!(editor: editor, authorization_request: token.authorization_request)
    end

    it 'groups by editor name' do
      result = query.top_editors('entreprise')

      expect(result.size).to eq(1)
      expect(result.first[:identifier]).to eq(editor.name)
      expect(result.first[:calls]).to eq(2)
    end
  end

  describe 'excluded controllers' do
    it 'ignores ping/uptime traffic' do
      create(:access_log, controller: 'ping', status: '200', token: token)

      expect(query.top_tokens('entreprise').size).to eq(2)
    end
  end
end
