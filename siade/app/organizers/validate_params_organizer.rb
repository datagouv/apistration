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
        context.fail! if context.errors.any?
      end
    end
  end
end
