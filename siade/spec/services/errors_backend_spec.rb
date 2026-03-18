# frozen_string_literal: true

RSpec.describe ErrorsBackend, type: :service do
  let(:instance) { ErrorsBackend.instance }

  describe '#get' do
    subject { instance.get(code) }

    context 'with valid code' do
      let(:code) { '00100' }

      it { is_expected.to be_present }
    end

    context 'with invalid code' do
      let(:code) { '9001' }

      it { is_expected.to be_nil }
    end
  end

  describe '#provider_from_code' do
    subject { instance.provider_from_code(code) }

    context 'with valid code' do
      let(:code) { '01123' }

      it { is_expected.to eq('INSEE') }
    end

    context 'with invalid code' do
      let(:code) { '99123' }

      it { is_expected.to be_nil }
    end
  end

  describe '#provider_code_from_name' do
    subject { instance.provider_code_from_name(name) }

    context 'with valid name' do
      let(:name) { 'INSEE' }

      it { is_expected.to eq('01') }
    end

    context 'with invalid name' do
      let(:name) { 'Dummy' }

      it { is_expected.to be_nil }
    end
  end
end
