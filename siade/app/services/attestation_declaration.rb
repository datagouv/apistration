class AttestationDeclaration
  class << self
    def for(retriever)
      find(key_for(retriever))
    end

    def find(key)
      key.split('/').reduce(Rails.application.config_for(:proof_attestations)) do |declaration, segment|
        declaration.fetch(segment.to_sym)
      end
    end

    def key_for(retriever)
      retriever.name.underscore
    end
  end
end
