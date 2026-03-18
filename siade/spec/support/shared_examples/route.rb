RSpec.shared_examples 'standard_siren_route' do |endpoint|
  it 'route to' do
    expect(get("/#{prefix_route}#{endpoint}/#{valid_siren}")).
    to route_to(controller: "#{prefix_controller}#{endpoint}", action: 'show', siren: valid_siren)
  end
end

RSpec.shared_examples 'standard_siret_route' do |endpoint|
  it 'route to' do
    expect(get("/#{prefix_route}#{endpoint}/#{valid_siret}")).
    to route_to(controller: "#{prefix_controller}#{endpoint}", action: 'show', siret: valid_siret)
  end
end
