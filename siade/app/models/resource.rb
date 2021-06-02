class Resource < Hash
  include Hashie::Extensions::MethodAccess
  include Hashie::Extensions::MergeInitializer
end
