require 'rails_helper'

RSpec.describe Organization do
  it 'has a valid factory' do
    expect(build(:organization)).to be_valid
    expect(build(:organization, :with_insee_payload, siret: '13002526500013')).to be_valid
  end

  describe 'INSEE payload accessors' do
    subject(:organization) { build(:organization, insee_payload:) }

    context 'with a complete payload' do
      subject(:organization) { build(:organization, :with_insee_payload, siret: '13002526500013') }

      it 'extracts the values' do
        expect(organization.denomination).to eq('DIRECTION INTERMINISTERIELLE DU NUMERIQUE')
        expect(organization.code_commune_etablissement).to be_present
        expect(organization.code_postal_etablissement).to be_present
      end
    end

    [
      ['an empty payload', {}],
      ['a payload without etablissement', { 'header' => {} }],
      ['a payload without unite legale nor adresse', { 'etablissement' => {} }],
      ['a payload whose etablissement is not a hash', { 'etablissement' => 'oops' }],
      ['a payload which is a string', '<html>Maintenance - INSEE</html>']
    ].each do |description, payload|
      context "with #{description}" do
        let(:insee_payload) { payload }

        it 'returns nil instead of raising' do
          expect(organization.denomination).to be_nil
          expect(organization.code_commune_etablissement).to be_nil
          expect(organization.code_postal_etablissement).to be_nil
        end
      end
    end
  end
end
