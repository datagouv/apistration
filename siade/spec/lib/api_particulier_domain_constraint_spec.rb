require 'spec_helper'

RSpec.describe APIParticulierDomainConstraint do
  let(:request) { instance_double(ActionDispatch::Request) }

  context 'when v3_and_more is false' do
    subject { described_class.new }

    context 'when the request host matches /particulier\.api/' do
      before do
        allow(request).to receive(:host).and_return('particulier.api.example.com')
      end

      context 'when the api_version is valid' do
        it 'returns true' do
          expect(subject.matches?(request)).to be true
        end
      end

      context 'when the api_version is invalid' do
        it 'returns false' do
          expect(subject.matches?(request)).to be true
        end
      end
    end

    context 'when the request host does not match /particulier\.api/' do
      before do
        allow(request).to receive(:host).and_return('example.com')
      end

      it 'returns false' do
        expect(subject.matches?(request)).to be false
      end
    end
  end

  context 'when v3_and_more is true' do
    subject { described_class.new(v3_and_more: true) }

    context 'when the request host matches /particulier\.api/' do
      before do
        allow(request).to receive(:host).and_return('particulier.api.example.com')
      end

      context 'when the api_version is valid' do
        before do
          allow(request).to receive(:path_parameters).and_return(api_version: '3')
        end

        it 'returns true' do
          expect(subject.matches?(request)).to be true
        end
      end

      context 'when the api_version is invalid' do
        before do
          allow(request).to receive(:path_parameters).and_return(api_version: 'invalid')
        end

        it 'returns false' do
          expect(subject.matches?(request)).to be false
        end
      end
    end

    context 'when the request host does not match /particulier\.api/' do
      before do
        allow(request).to receive(:host).and_return('example.com')
      end

      it 'returns false' do
        expect(subject.matches?(request)).to be false
      end
    end
  end
end
