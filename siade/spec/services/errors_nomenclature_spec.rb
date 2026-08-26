RSpec.describe 'errors nomenclature' do # rubocop:disable RSpec/DescribeClass
  # `00` is documented as "no data provider involved". A handful of legacy
  # FranceConnect token codes predate that rule and use an unallocated `50`
  # prefix; they are pending a reclassification of their own.
  LEGACY_UNALLOCATED_PREFIX_CODES = %w[50001 50002 50003 50004].freeze

  let(:backend) { ErrorsBackend.instance }

  before { Rails.application.eager_load! }

  describe 'every configured code belongs to a known data provider' do
    it 'has no code whose prefix is unallocated' do
      configured_codes = YAML.load_file(Rails.root.join('config/errors.yml'), aliases: true)
        .filter_map { |entry| entry['code']&.to_s }

      unallocated = configured_codes
        .reject { |code| LEGACY_UNALLOCATED_PREFIX_CODES.include?(code) }
        .reject { |code| backend.provider_from_code(code) }

      expect(unallocated).to be_empty,
        "codes with an unallocated provider prefix: #{unallocated.inspect}"
    end
  end

  describe 'an error raised from a provider response names that provider' do
    it 'has no `00` prefixed error declared on a ValidateResponse' do
      offenders = ValidateResponse.descendants.flat_map do |validator|
        ErrorRegistry.direct_declarations_for(validator).filter_map do |declaration|
          code = declaration.error_class.build_example(provider_name: 'CNAV', **declaration.options).code

          "#{validator}: #{declaration.error_class} -> #{code}" if code.start_with?('00')
        end
      end

      expect(offenders).to be_empty, <<~MESSAGE
        A `00` prefix means "no data provider was queried". These errors are emitted
        from a ValidateResponse, hence after a provider round trip, so they must carry
        that provider's prefix (see ProviderUnprocessableEntityError):

        #{offenders.join("\n")}
      MESSAGE
    end
  end
end
