RSpec.describe DGFIP::TVA::MakeRequest, type: :make_request do
  describe '.call' do
    subject(:make_call) { described_class.call(params:, tva_number:) }

    let(:params) { { siren: '217500016' } }
    let(:tva_number) { 'FR72217500016' }
    let(:issued_date_greater) do
      hourly_bucket = Time.now.to_i / described_class::CACHE_BUSTING_PERIOD_IN_SECONDS

      (described_class::CACHE_BUSTING_FIRST_DATE + (hourly_bucket % described_class::CACHE_BUSTING_DATES_COUNT)).iso8601
    end
    let!(:stubbed_request) do
      Timecop.freeze(Time.utc(2026, 6, 26))

      stub_request(:get, "#{DGFIP::TVA::MakeRequest::BASE_URL}/api/resources/#{DGFIP::TVA::MakeRequest::RESOURCE_ID}/data/")
        .with(query: { 'vat_no__exact' => '72217500016', 'issued_date__greater' => issued_date_greater })
        .to_return(status: 200, body: { data: [{ vat_no: '72217500016' }], meta: { total: 1 } }.to_json)
    end

    after { Timecop.return }

    it_behaves_like 'a make request with working mocking_params'

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'calls the tabular API with the exact TVA number' do
      make_call

      expect(stubbed_request).to have_been_requested
    end
  end

  describe 'cache busting date' do
    let(:oldest_issued_date_of_the_dataset) { Date.new(1900, 12, 31) }

    after { Timecop.return }

    def cache_busting_date_at(time)
      Timecop.freeze(time)

      described_class.new.send(:cache_busting_date)
    end

    it 'changes on the next hour' do
      expect(cache_busting_date_at(Time.utc(2026, 6, 26, 11, 0)))
        .not_to eq(cache_busting_date_at(Time.utc(2026, 6, 26, 10, 0)))
    end

    it 'stays stable within the hour' do
      expect(cache_busting_date_at(Time.utc(2026, 6, 26, 10, 59)))
        .to eq(cache_busting_date_at(Time.utc(2026, 6, 26, 10, 0)))
    end

    it 'never filters out a row of the dataset' do
      latest_date = described_class::CACHE_BUSTING_FIRST_DATE + described_class::CACHE_BUSTING_DATES_COUNT - 1

      expect(latest_date).to be < oldest_issued_date_of_the_dataset
    end
  end
end
