class RNAIdFormatValidatable
  include ActiveModel::Validations

  attr_accessor :rna_id

  validates :rna_id, rna_id_format: true
end

RSpec.describe RNAIdFormatValidator do
  subject { RNAIdFormatValidatable.new }

  it 'validates rna_id that has a W and 9 digits' do
    subject.rna_id = 'W123456789'

    expect(subject).to be_valid
  end

  it 'validates rna_id that has a W a digit a letter and 7 digits' do
    subject.rna_id = 'W9N1004065'
    expect(subject).to be_valid
  end

  it 'validates boring rna id...' do
    rna_ids = %w[0714000529 0802008849 0792002235 0092001582 0071001750]
    rna_ids.each do |id|
      subject.rna_id = id
      expect(subject).to be_valid
    end
  end

  it 'rejects ill-formated rna id' do
    subject.rna_id = 'W1234567890'

    expect(subject).not_to be_valid
    expect(subject.errors.messages[:rna_id]).to include('W followed by 9 digits only')
  end
end
