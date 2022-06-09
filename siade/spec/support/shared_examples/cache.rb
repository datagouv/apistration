RSpec.shared_examples 'it retrieves cached errors' do
  context 'when the cached value is an error' do
    before do
      EncryptedCache.write(cache_key, { errors: cached_result })
    end

    let(:cached_result) { [BadRequestError.new('so bad')] }

    it { is_expected.to be_a_failure }

    it 'returns the errors' do
      expect(subject.errors.map(&:to_h)).to eq(cached_result.map(&:to_h))
    end

    it 'does not make a call to the provider' do
      expect(retriever_organizer).not_to receive(:call)

      subject
    end

    it 'has the cached data in context' do
      expect(subject.cached_data).to be_present
    end
  end
end

RSpec.shared_examples 'it caches the provider errors' do
  context 'when the call to the provider ends in error' do
    # rubocop:disable RSpec/VerifiedDoubles
    let(:organizer_result) do
      double(
        'retriever',
        success?: false,
        cacheable:,
        errors:
      )
    end

    let(:errors) { [BadRequestError.new('so bad')] }
    # rubocop:enable RSpec/VerifiedDoubles

    context 'when the error should be written into cache' do
      let(:cacheable) { true }

      it { is_expected.to be_a_failure }

      it 'writes the errors in the cache' do
        subject
        cached_errors = EncryptedCache.read(cache_key).fetch(:errors)

        expect(cached_errors.map(&:to_h)).to eq(errors.map(&:to_h))
      end

      it 'does not have the cached data in context' do
        expect(subject.cached_data).not_to be_present
      end

      context 'when no cache key nor expiration time are provided' do
        it 'caches with default values' do
          expect(EncryptedCache)
            .to receive(:write)
            .with(cache_key, anything, expires_in: 1.hour)
            .and_call_original

          subject
        end
      end

      context 'when cache key or expiration time are provided' do
        subject do
          described_class.call(
            retriever_organizer:,
            retriever_params:,
            expires_in: 2.days,
            cache_key: 'dat_key'
          )
        end

        it 'caches with the provided values' do
          expect(EncryptedCache)
            .to receive(:write)
            .with('dat_key', anything, expires_in: 2.days)
            .and_call_original

          subject
        end
      end

      it 'returns the error' do
        expect(subject.errors).to eq(errors)
      end
    end

    context 'when the error should not be cached' do
      let(:cacheable) { false }

      it { is_expected.to be_a_failure }

      it 'does not writes the error in the cache' do
        subject

        expect(Rails.cache.read(cache_key)).not_to be_present
      end

      it 'returns the error' do
        expect(subject.errors).to eq(errors)
      end
    end
  end
end
