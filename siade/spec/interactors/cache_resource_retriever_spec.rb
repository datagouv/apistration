RSpec.describe CacheResourceRetriever do
  DummyResourceRetriever = Class.new(RetrieverOrganizer)

  subject { described_class.call(retriever_organizer:, retriever_params:) }

  let(:retriever_params) do
    {
      such: :param,
      one: :more
    }
  end

  let(:retriever_organizer) do
    DummyResourceRetriever
  end

  let(:cache_key) do
    "#{retriever_organizer.to_s.tableize}:#{retriever_params.to_query}"
  end

  context 'when the resource had been cached' do
    before do
      EncryptedCache.write(cache_key, { resource: cached_result })
    end

    context 'when the cached value is a Resource' do
      let(:cached_result) { Resource.new(what: :ever) }

      it { is_expected.to be_a_success }

      it 'returns the resource' do
        expect(subject.resource.to_h).to eq(cached_result.to_h)
      end

      it 'does not call the retriever organizer' do
        expect(retriever_organizer).not_to receive(:call)

        subject
      end

      it 'has the cached data in context' do
        expect(subject.cached_data).to be_present
      end
    end

    it_behaves_like 'it retrieves cached errors'
  end

  context 'when the result is not present in cache' do
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
          resource:,
          cacheable: true
        )
      end

      let(:resource) { Resource.new(much: :success) }
      # rubocop:enable RSpec/VerifiedDoubles

      it { is_expected.to be_a_success }

      it 'returns the resource' do
        expect(subject.resource).to eq(resource)
      end

      it 'writes the resource into the cache' do
        subject

        cache = EncryptedCache.read(cache_key).fetch(:resource)
        expect(cache.to_h).to eq({ much: :success })
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
    end

    it_behaves_like 'it caches the provider errors'
  end
end
