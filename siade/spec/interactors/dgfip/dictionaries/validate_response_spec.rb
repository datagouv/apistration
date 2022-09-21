RSpec.describe DGFIP::Dictionaries::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:) }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    context 'with a valid json body' do
      let(:body) do
        {
          dictionnaire: [
            {
              numero_imprime: '2050',
              millesimes: {
                millesime: '201501',
                statut_version: 'X',
                declaration: [
                  {
                    code_absolu: '2006345',
                    code_EDI: 'XX:C123:4567:8:XXX',
                    code: 'XX',
                    intitule: 'Déposé néant',
                    code_type_donnee: 'XXX',
                    code_nref: '123456'
                  }
                ]
              }
            }
          ]
        }.to_json
      end

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }

      its(:cacheable) { is_expected.to be(true) }
    end

    context 'with a body which is not a json' do
      context 'with an empty body' do
        let(:body) { nil }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

        its(:cacheable) { is_expected.to be(false) }
      end
    end
  end

  context 'with an http not ok' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

    its(:cacheable) { is_expected.to be(false) }
  end
end
