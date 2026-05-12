RSpec.describe Admin::TokenConsumptionQuery do
  subject(:query) { described_class.new(filter) }

  let(:token) { create(:token) }
  let(:controller_name) { 'api_entreprise/v3_and_more/insee/etablissements' }

  before do
    create(:access_log, controller: controller_name, status: '200', token: token, duration: '500')
    create(:access_log, controller: controller_name, status: '404', token: token, duration: '300')
  end

  describe 'with token_id filter' do
    let(:filter) { Admin::StatisticsFilter.new(token_id: token.id) }

    describe '#habilitations' do
      it 'returns authorization requests with call counts' do
        result = query.habilitations.to_a

        expect(result.size).to eq(1)
        expect(result.first.calls_count.to_i).to eq(2)
      end
    end

    describe '#tokens_with_consumption' do
      it 'returns tokens with call counts' do
        result = query.tokens_with_consumption.to_a

        expect(result.size).to eq(1)
        expect(result.first.calls_count.to_i).to eq(2)
      end
    end

    describe '#consumption_by_day' do
      it 'returns daily breakdown with unique/non_unique' do
        result = query.consumption_by_day

        expect(result).to be_an(Array)
        expect(result.first).to include(:bucket, :unique, :non_unique)
      end
    end

    describe '#consumption_by_api_and_status' do
      it 'groups by controller and status' do
        result = query.consumption_by_api_and_status

        expect(result.size).to eq(2)
        expect(result.map { |r| r[:status] }).to contain_exactly('200', '404')
      end
    end

    describe '#recent_requests' do
      it 'returns recent access logs ordered by timestamp desc' do
        result = query.recent_requests

        expect(result.size).to eq(2)
        expect(result.first.timestamp).to be >= result.last.timestamp
      end
    end
  end

  describe 'with external_id filter' do
    let(:filter) { Admin::StatisticsFilter.new(external_id: token.authorization_request.external_id) }

    it 'filters habilitations by external_id' do
      other_token = create(:token)
      create(:access_log, controller: controller_name, status: '200', token: other_token)

      result = query.habilitations.to_a
      external_ids = result.map(&:external_id)

      expect(external_ids).to include(token.authorization_request.external_id)
      expect(external_ids).not_to include(other_token.authorization_request.external_id)
    end
  end

  describe 'token_id validation' do
    let(:filter) { Admin::StatisticsFilter.new(token_id: 'not-a-uuid') }

    it 'raises RecordNotFound for invalid UUID' do
      expect { query.habilitations.to_a }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
