RSpec.shared_context 'with generator' do
  destination File.expand_path('../../../tmp', __dir__)

  before { prepare_destination }

  after { prepare_destination }
end
