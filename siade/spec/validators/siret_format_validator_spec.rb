class SiretFormatValidatable
  include ActiveModel::Validations

  attr_accessor :siret

  validates :siret, siret_format: true
end

RSpec.describe SiretFormatValidator do
  subject { SiretFormatValidatable.new }

  let(:la_poste_siret) { '35600000000048' }

  it 'validates la poste siret' do
    subject.siret = la_poste_siret

    expect(subject).to be_valid
  end

  it 'validates siret that has 14 digits' do
    subject.siret = valid_siret

    expect(subject).to be_valid
  end

  it 'rejects siret that does not have 14 digits' do
    subject.siret = '1234567891234567'

    expect(subject).not_to be_valid
    expect(subject.errors.messages[:siret]).to include('14 digits only')
  end

  it 'rejects siret that have 14 chars long including a letter' do
    subject.siret = '1234567891234A'

    expect(subject).not_to be_valid
    expect(subject.errors.messages[:siret]).to include('14 digits only')
  end

  it 'rejects siret that have 14 digits but no good checksum' do
    subject.siret = invalid_siret

    expect(subject).not_to be_valid
    expect(subject.errors.messages[:siret]).to include(
      'must have luhn_checksum ok or be a la poste siret'
    )
  end

  it 'rejects siret with whitespaces' do
    subject.siret = "\t\r\n#{valid_siret}"

    expect(subject).not_to be_valid
    expect(subject.errors.messages[:siret]).to include('14 digits only')
  end

  it 'rejects siret which have no good checksum but match la poste siren' do
    subject.siret = '12345356000000'

    expect(subject).not_to be_valid
    expect(subject.errors.messages[:siret]).to include(
      'must have luhn_checksum ok or be a la poste siret'
    )
  end
end
