RSpec.describe SIADE::V2::Utilities::HTTPCode do
  subject { described_class }

  it 'returns 200' do
    expect(subject.generate_best_http_code([200, 200, 200])).to eq(200)
  end

  it 'returns 206' do
    expect(subject.generate_best_http_code([206, 200, 200])).to eq(206)
    expect(subject.generate_best_http_code([200, 206, 200])).to eq(206)
    expect(subject.generate_best_http_code([200, 200, 206])).to eq(206)

    expect(subject.generate_best_http_code([404, 500, 200])).to eq(206)
    expect(subject.generate_best_http_code([404, 503, 206])).to eq(206)
    expect(subject.generate_best_http_code([200, 422, 502])).to eq(206)
    expect(subject.generate_best_http_code([206, 404, 502])).to eq(206)
    expect(subject.generate_best_http_code([206, 503, 200])).to eq(206)
  end

  it 'returns 404' do
    expect(subject.generate_best_http_code([404, 422, 400])).to eq(404)
    expect(subject.generate_best_http_code([502, 404, 500])).to eq(404)
    expect(subject.generate_best_http_code([503, 404, 422])).to eq(404)
    expect(subject.generate_best_http_code([500, 422, 404])).to eq(404)
  end

  it 'returns 4XX' do
    expect(subject.generate_best_http_code([400, 400, 400])).to eq(400)
    expect(subject.generate_best_http_code([422, 400, 422])).to eq(422)
    expect(subject.generate_best_http_code([422, 422, 422])).to eq(422)
  end

  it 'returns 5XX' do
    expect(subject.generate_best_http_code([])).to eq(500)
    expect(subject.generate_best_http_code([400, 422, 500])).to eq(500)
    expect(subject.generate_best_http_code([502, 422, 500])).to eq(502)
    expect(subject.generate_best_http_code([500, 422, 503])).to eq(503)
    expect(subject.generate_best_http_code([503, 502, 422])).to eq(503)
  end

  it 'logs an error' do
    expect(Rails.logger).to receive(:error)
    expect(subject.generate_best_http_code([200, 900])).to eq(500)
  end
end
