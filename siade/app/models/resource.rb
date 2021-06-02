class Resource < Hash
  include Hashie::Extensions::MethodAccess
  include Hashie::Extensions::MergeInitializer
  include Hashie::Extensions::IndifferentAccess
end
