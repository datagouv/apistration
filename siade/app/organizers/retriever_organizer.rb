class RetrieverOrganizer < ApplicationOrganizer
  class StatusNotDefined < Exception; end

  def self.inherited(klass)
    klass.class_eval do
      before do
        context.resource = nil
        context.status   = nil
        context.errors   = []
      end

      after do
        if context.status.nil?
          status_not_defined!
        end
      end
    end
  end

  def status_not_defined!
    raise StatusNotDefined
  end
end
