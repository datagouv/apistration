RSpec.describe CacheResourceRetriever do
  subject { described_class.call(retriever_organizer:, retriever_params:) }

  let(:retriever_params) do
    {
      such: :param,
      one: :more
    }
  end

  let(:retriever_organizer) do
    Class.new(RetrieverOrganizer)
  end

  let(:cache_key) do
    "#{retriever_organizer.to_s.tableize}:#{retriever_params.to_query}"
  end

  context 'when data had been cached' do
    context 'when bundled data had been cached' do
      before do
        EncryptedCache.write(cache_key, { bundled_data: cached_data })
      end

      let(:cached_data) do
        BundledData.new(data: 'much data', context: { very: 'meta' })
      end

      it { is_expected.to be_a_success }

      it 'returns the cached data' do
        expect(subject.bundled_data).to have_attributes({
          data: 'much data',
          context: { very: 'meta' }
        })
      end

      it 'does not call the retriever organizer' do
        expect(retriever_organizer).not_to receive(:call)

        subject
      end

      it 'has the cached data in context' do
        expect(subject.cached_data).to be_present
      end
    end

    context 'when errors had been cached' do
      before do
        EncryptedCache.write(cache_key, { errors: cached_errors })
      end

      let(:cached_errors) { [BadRequestError.new('so bad')] }

      it { is_expected.to be_a_failure }

      it 'returns the cached errors' do
        expect(subject.errors.map(&:to_h)).to eq(cached_errors.map(&:to_h))
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

  context 'when nothing had been cached' do
    before do
      EncryptedCache.write(cache_key, nil)

      allow(retriever_organizer).to receive(:call).with(params: retriever_params).and_return(organizer_result)
    end

    context 'when the call to the provider is a success' do
      # rubocop:disable RSpec/VerifiedDoubles
      let(:organizer_result) do
        double(
          'retriever',
          success?: true,
          bundled_data:,
          cacheable: true
        )
      end
      # rubocop:enable RSpec/VerifiedDoubles

      let(:bundled_data) { BundledData.new(data: 'wow data', context: { so: 'meta' }) }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to eq([]) }

      it 'returns the data' do
        expect(subject.bundled_data).to have_attributes({
          data: 'wow data',
          context: { so: 'meta' }
        })
      end

      it 'writes the retrieved data into the cache' do
        subject

        cache = EncryptedCache.read(cache_key).fetch(:bundled_data)

        expect(cache).to be_a(BundledData)
        expect(cache).to have_attributes({
          data: 'wow data',
          context: { so: 'meta' }
        })
      end

      it 'does not have the cached data in context' do
        expect(subject.cached_data).not_to be_present
      end

      context 'when no cache key nor expiration time are provided' do
        let(:default_key) { cache_key }
        let(:default_expiration_time) { 1.hour }

        it 'writes into the cache with default parameters' do
          expect(EncryptedCache)
            .to receive(:write)
            .with(default_key, anything, expires_in: default_expiration_time)
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
    end

    context 'when the call to the provider is a failure' do
      # rubocop:disable RSpec/VerifiedDoubles
      let(:organizer_result) do
        double(
          'retriever',
          success?: false,
          cacheable:,
          errors:
        )
      end
      # rubocop:enable RSpec/VerifiedDoubles

      let(:errors) { [BadRequestError.new('so bad')] }

      context 'when errors should be written into cache' do
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
          let(:default_key) { cache_key }
          let(:default_expiration_time) { 1.hour }

          it 'caches with default values' do
            expect(EncryptedCache)
              .to receive(:write)
              .with(default_key, anything, expires_in: default_expiration_time)
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

          expect(EncryptedCache.read(cache_key)).not_to be_present
        end

        it 'returns the error' do
          expect(subject.errors).to eq(errors)
        end
      end
    end
  end
end
