RSpec.describe DGFIP::LiassesFiscales::BuildResource, type: :build_resource do
  describe '.call' do
    subject(:builder) { described_class.call(response:) }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:resource) { builder.bundled_data.data }

    describe 'real payload', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
      let(:body) { DGFIP::LiassesFiscales::MakeRequest.call(cookie:, params:).response.body }
      let(:cookie) { DGFIP::Authenticate.call.cookie }
      let(:params) do
        {
          siren: valid_siren(:liasse_fiscale),
          user_id: valid_dgfip_user_id,
          year: 2017
        }
      end

      it { expect(resource).to be_a(Resource) }

      it { expect(resource.to_h).to match(a_hash_including(:declarations, :obligations_fiscales)) }

      it 'has no-nil values and at least one value in each entries' do
        resource.declarations.each do |declaration|
          declaration[:donnees].each do |data|
            expect(data[:valeurs]).not_to include(nil)
            expect(data[:valeurs]).not_to be_empty
          end
        end
      end

      it 'one obligations fiscales entries' do
        expect(resource.obligations_fiscales.count).to eq(1)
      end
    end

    describe 'with a payload which has repeated entries' do
      let(:payload_name) { 'one_obligation_fiscale' }

      let(:body) { extract_dgfip_liasses_fiscales_payload(payload_name).to_json }

      describe 'non repeated entries' do
        it 'creates an array for values with the value' do
          example_data_with_repeated_entries = resource.declarations.find do |declaration|
            declaration[:numero_imprime] == '2033A'
          end

          data = example_data_with_repeated_entries[:donnees].find do |datum|
            datum[:code_nref] == '304330'
          end

          expect(data[:valeurs]).to eq(['11111'])
        end
      end

      describe 'repeated entries' do
        it 'creates an array for values with all values ordered' do
          example_data_with_repeated_entries = resource.declarations.find do |declaration|
            declaration[:numero_imprime] == '2033F'
          end

          data = example_data_with_repeated_entries[:donnees].find do |datum|
            datum[:code_nref] == '304816'
          end

          expect(data[:valeurs]).to eq(%w[75001 75002])
        end
      end
    end

    describe 'with a payload which has repeated obligations fiscales' do
      let(:payload_name) { 'two_obligations_fiscales' }

      let(:body) { extract_dgfip_liasses_fiscales_payload(payload_name).to_json }

      it 'has multiple obligations fiscales entries' do
        expect(resource.obligations_fiscales.count).to eq(2)
      end
    end
  end
end
