RSpec.shared_examples 'a valid error' do
  subject do
    instance
  rescue NameError
    described_class.new
  end

  %w[
    title
    code
    detail
    source
    meta
  ].each do |method|
    it "implements ##{method}" do
      expect {
        subject.public_send(method)
      }.not_to raise_error
    end
  end

  it 'has a all required attributes defined' do
    %w[
      title
      code
      detail
    ].each do |method|
      expect(subject.public_send(method)).to be_present
    end
  end

  it 'has a valid error code format' do
    expect(subject.send(:code)).to match(/^\d{5}$/)
  end
end
