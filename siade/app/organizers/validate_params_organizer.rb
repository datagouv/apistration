class ValidateParamsOrganizer < ApplicationOrganizer
  def self.inherited(klass)
    klass.class_eval do
      before do
        context.errors ||= []
        context.wait_to_fail = true
      end
    end

    klass.class_eval do
      after do
        if context.errors.any?
          context.fail!
        end
      end
    end
  end
end
