# rubocop:disable RSpec/SubjectStub
RSpec.describe RenewINSEETokenService do
  subject(:service) { described_class.new }

  let(:not_valid_token) { 'not_valid_token' }
  let(:missing_file) { Pathname.new('missing_file.yaml') }

  context 'not renewing when not expired' do
    before do
      allow(service).to receive(:filename).and_return(missing_file)

      file = File.new(service.send(:filename), 'w+')
      content = <<-YML
        token: not_valid_token
        expiration_date: #{(DateTime.now + 1.month).to_i}
        expires_in: 360
      YML
      file.write(content.unindent)
      file.close

      service.call
    end

    after { File.delete(missing_file) }

    its(:current_token_expired?) { is_expected.to be false }
  end

  shared_examples 'renew token' do
    after { File.delete(missing_file) }

    it 'renew the token' do
      new_token = YAML.load_file(service.send(:filename))['token']
      expect(new_token).to be_not_nil.and not_eq not_valid_token
    end
  end

  shared_examples 'renew expiration date' do
    before do
      allow(service).to receive(:filename).and_return(missing_file)
    end

    after { File.delete(missing_file) }

    it 'renew the expiration date' do
      new_expiration_date = YAML.load_file(service.send(:filename))['expiration_date']
      expect(new_expiration_date).not_to be_nil
    end

    it 'renew the -expires in- duration' do
      new_expires_in = YAML.load_file(service.send(:filename))['expires_in']
      expect(new_expires_in).not_to be_nil
    end
  end

  describe 'when renewing the token', vcr: { cassette_name: 'insee/token' } do
    context 'token file does not exists' do
      before do
        allow(service).to receive(:filename).and_return(missing_file)
        service.call
      end

      it_behaves_like 'renew token'
    end

    context 'token file already exists' do
      before do
        allow(service).to receive(:filename).and_return(missing_file)

        file = File.new(service.send(:filename), 'w+')
        content = <<-YML
        token: not_valid_token
        expiration_date: 0
        expires_in: 360
        YML
        file.write(content.unindent)
        file.close

        service.call
      end

      it_behaves_like 'renew token'
      it_behaves_like 'renew expiration date'
    end

    context 'force regenration ignoring expiration date' do
      before do
        allow(service).to receive(:filename).and_return(missing_file)
        service.call(force: true)
      end

      it_behaves_like 'renew token'
      it_behaves_like 'renew expiration date'
    end

    context 'when writing the token' do
      before do
        allow(File).to receive(:write).and_raise(StandardError)
      end

      it 'raises an exception' do
        expect(Rails.logger).to receive(:error).with('Failed to write new INSEE token (StandardError)')
        service.call(force: true)
      end
    end
  end
end
# rubocop:enable RSpec/SubjectStub
