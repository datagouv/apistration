module AuthenticationStub
  def stub_authentication_with_jwt_user(user = yes_jwt_user)
    allow_any_instance_of(HandleTokens).to receive(:authenticate_user!).and_wrap_original do |method_proxy, *| # rubocop:disable RSpec/AnyInstance
      method_proxy.receiver.instance_variable_set(:@current_user, user)
      true
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationStub
end
