RSpec.describe 'Errors nomenclature declarations', type: :acceptance do
  let(:unversioned_controllers_under_v3) { %w[ping api_entreprise/errors_nomenclature] }

  let(:routed_controllers) do
    Rails.application.routes.routes.filter_map { |route|
      controller = route.defaults[:controller]
      next unless controller&.include?('v3_and_more')

      "#{controller}_controller".camelize.constantize
    }.uniq
  end

  def versioned_v3_and_more_path?(path)
    path.start_with?('/v:api_version/') || path.match?(%r{\A(/api)?/v(?:[3-9]|\d{2,})/})
  end

  it 'serves every v3+ route from a v3_and_more controller, which the nomenclature guards scan' do
    outside = Rails.application.routes.routes.filter_map { |route|
      controller = route.defaults[:controller].to_s
      next unless versioned_v3_and_more_path?(route.path.spec.to_s)
      next if controller.empty? || controller.include?('v3_and_more') || unversioned_controllers_under_v3.include?(controller)

      "#{route.path.spec} -> #{controller}"
    }.uniq

    expect(outside).to be_empty, <<~MESSAGE
      These v3+ routes, versioned by the :api_version segment or by a hard-coded v3 or later,
      are served outside the v3_and_more namespace, where no nomenclature
      guard looks: move their controller under it and declare it like the others.

      #{outside.join("\n")}
    MESSAGE
  end

  it 'has one declaration per routed endpoint' do
    undeclared = routed_controllers.reject(&:errors_nomenclature_declaration)

    expect(undeclared).to be_empty,
      "controllers with no `nomenclature organizers:` declaration: #{undeclared.inspect}"
  end

  it 'declares the organizer each version actually runs' do
    mismatches = routed_controllers.flat_map do |controller_class|
      controller_class.errors_nomenclature_declaration.organizers.filter_map do |version, declared|
        actual = organizer_used_by(controller_class, version)

        "#{controller_class} v#{version}: declares #{declared}, runs #{actual}" unless actual == declared
      end
    end

    expect(mismatches).to be_empty, mismatches.join("\n")
  end

  it 'keeps an endpoint that is deliberately not documented out of the nomenclature' do
    undocumented = routed_controllers.reject { |controller_class| controller_class.errors_nomenclature_declaration.documented? }

    expect(undocumented).to contain_exactly(
      APIEntreprise::V3AndMore::INPI::RNE::BeneficiairesEffectifsOpenDataController,
      APIEntreprise::V3AndMore::IntrospectController,
      APIParticulier::V3AndMore::IntrospectController
    )
    expect(ErrorsNomenclature.new(:entreprise).to_h['endpoints'])
      .not_to have_key('api_entreprise_v3_inpi_rne_beneficiaires_effectifs_open_data')
  end

  it 'declares only versions the endpoint can serialize' do
    unserializable = routed_controllers.flat_map do |controller_class|
      serializer_module = controller_class.new.send(:serializer_module)

      controller_class.errors_nomenclature_declaration.versions.filter_map do |version|
        "#{controller_class} v#{version}: #{serializer_module} has no V#{version}" unless serializer_module.const_defined?(:"V#{version}")
      end
    end

    expect(unserializable).to be_empty, unserializable.join("\n")
  end

  def organizer_used_by(controller_class, version)
    controller = controller_class.new
    controller.define_singleton_method(:api_version) { version }
    controller.define_singleton_method(:retrieve_payload_data) { |organizer, **| organizer }

    controller.send(:organizer)
  end
end
