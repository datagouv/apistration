RSpec.describe DGFIP::TVA::SelectTVANumber, type: :interactor do
  subject { described_class.call(tva_number: 'FR82200071900', response:) }

  let(:response) { instance_double(Net::HTTPOK, body: { data: rows }.to_json) }

  context 'when two numbers without the computed one share the most recent issued date' do
    let(:rows) do
      [
        { vat_no: '8K200071900', issued_date: '2017-10-01' },
        { vat_no: '7X200071900', issued_date: '2017-10-01' },
        { vat_no: '4W200071900', issued_date: '2017-01-01' }
      ]
    end

    its(:numero_tva) { is_expected.to eq('FR8K200071900') }
  end
end
