RSpec.describe 'Errors nomenclature declarations', type: :acceptance do
  let(:routed_controllers) do
    Rails.application.routes.routes.filter_map { |route|
      controller = route.defaults[:controller]
      next unless controller&.include?('v3_and_more')

      "#{controller}_controller".camelize
        .sub('ApiEntreprise', 'APIEntreprise')
        .sub('ApiParticulier', 'APIParticulier')
        .constantize
    }.uniq
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
