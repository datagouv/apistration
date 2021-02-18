class RetrieverOrganizer < ApplicationOrganizer
  def self.inherited(klass)
    klass.class_eval do
      before do
        context.resource = nil
        context.status   = 200
        context.errors   = []
      end
    end
  end
end
